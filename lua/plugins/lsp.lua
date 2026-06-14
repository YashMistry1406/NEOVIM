return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        print("=== LSP CONFIG STARTING ===")

        -- 1. Capabilities
        local ok1, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        print("cmp_nvim_lsp loaded: " .. tostring(ok1))
        local capabilities = ok1 and cmp_nvim_lsp.default_capabilities()
            or vim.lsp.protocol.make_client_capabilities()

        -- 2. Mason
        local ok2, err2 = pcall(function()
            require("mason").setup()
        end)
        print("mason.setup ok: " .. tostring(ok2) .. " " .. tostring(err2 or ""))

        -- 3. Mason-lspconfig
        local ok3, err3 = pcall(function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "jdtls" },
                handlers = {
                    function(server_name)
                        if server_name == "jdtls" then return end
                        local ok, err = pcall(function()
                            require("lspconfig")[server_name].setup({
                                capabilities = capabilities,
                            })
                        end)
                        if not ok then
                            print("Handler error for " .. server_name .. ": " .. tostring(err))
                        end
                    end,
                    ["lua_ls"] = function()
                        local ok, err = pcall(function()
                            require("lspconfig").lua_ls.setup({
                                capabilities = capabilities,
                                settings = {
                                    Lua = {
                                        diagnostics = { globals = { "vim" } },
                                    },
                                },
                            })
                        end)
                        if not ok then
                            print("lua_ls handler error: " .. tostring(err))
                        end
                    end,
                },
            })
        end)
        print("mason-lspconfig.setup ok: " .. tostring(ok3) .. " " .. tostring(err3 or ""))

        -- 4. nvim-cmp
        local ok4, err4 = pcall(function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
            })
        end)
        print("cmp.setup ok: " .. tostring(ok4) .. " " .. tostring(err4 or ""))

        -- 5. Keybindings
        local ok5, err5 = pcall(function()
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP Keybindings",
                callback = function(event)
                    local opts = { buffer = event.buf }
                    -- LSP Info & Utilities (Neovim 0.10+ replacements for :LspInfo etc.)
                    vim.keymap.set('n', '<leader>li', function()
                        print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
                    end, { buffer = event.buf, desc = "LSP: Info (current buffer)" })

                    vim.keymap.set('n', '<leader>lI', function()
                        print(vim.inspect(vim.lsp.get_clients()))
                    end, { buffer = event.buf, desc = "LSP: Info (all clients)" })


                    --LSP: Restart (current buffer)
                    vim.keymap.set('n', '<leader>lr', function()
                        vim.cmd('write')
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        local names = vim.tbl_map(function(c) return c.name end, clients)
                        vim.notify("LSP Restarting: " .. table.concat(names, ", "), vim.log.levels.INFO)
                        for _, client in ipairs(clients) do
                            client:stop()
                        end
                        vim.defer_fn(function()
                            vim.cmd('edit')
                            vim.notify("LSP Restarted: " .. table.concat(names, ", "), vim.log.levels.INFO)
                        end, 500)
                    end, { buffer = event.buf, desc = "LSP: Restart (current buffer)" })

                    -- LSP: Restart ALL clients
                    vim.keymap.set('n', '<leader>lR', function()
                        vim.cmd('write')
                        local clients = vim.lsp.get_clients()
                        local names = vim.tbl_map(function(c) return c.name end, clients)
                        vim.notify("LSP Restarting ALL: " .. table.concat(names, ", "), vim.log.levels.INFO)
                        for _, client in ipairs(clients) do
                            client:stop()
                        end
                        vim.defer_fn(function()
                            vim.cmd('edit')
                            vim.notify("LSP Restarted ALL: " .. table.concat(names, ", "), vim.log.levels.INFO)
                        end, 500)
                    end, { buffer = event.buf, desc = "LSP: Restart ALL clients" })


                    -- Stop the LSP
                    vim.keymap.set('n', '<leader>ls', function()
                        vim.cmd('write')
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        local names = vim.tbl_map(function(c) return c.name end, clients)
                        vim.notify("LSP Stopping: " .. table.concat(names, ", "), vim.log.levels.WARN)
                        for _, client in ipairs(clients) do
                            client:stop()
                        end
                        vim.defer_fn(function()
                            vim.notify("LSP Stopped: " .. table.concat(names, ", "), vim.log.levels.WARN)
                        end, 500)
                    end, { buffer = event.buf, desc = "LSP: Stop (current buffer)" })


                    -- Start the LSP
                    vim.keymap.set('n', '<leader>la', function()
                        local buf = vim.api.nvim_get_current_buf()
                        local ft = vim.bo[buf].filetype
                        vim.notify("LSP Starting for filetype: " .. ft, vim.log.levels.INFO)
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        if #clients > 0 then
                            vim.notify("LSP already running: " .. table.concat(
                                vim.tbl_map(function(c) return c.name end, clients), ", "
                            ), vim.log.levels.WARN)
                            return
                        end
                        vim.notify("LSP Starting for filetype: " .. ft .. " (this may take a moment...)",
                            vim.log.levels.INFO)
                        vim.cmd('edit')

                        -- Poll every 500ms up to 10 times (5 seconds total) for slow servers like jdtls
                        local attempts = 0
                        local function check_started()
                            attempts = attempts + 1
                            local new_clients = vim.lsp.get_clients({ bufnr = 0 })
                            if #new_clients > 0 then
                                vim.notify("LSP Started: " .. table.concat(
                                    vim.tbl_map(function(c) return c.name end, new_clients), ", "
                                ), vim.log.levels.INFO)
                            elseif attempts < 10 then
                                vim.defer_fn(check_started, 500)
                            else
                                vim.notify("LSP failed to start for filetype: " .. ft, vim.log.levels.ERROR)
                            end
                        end

                        vim.defer_fn(check_started, 500)
                    end, { buffer = event.buf, desc = "LSP: Start" })


                    vim.keymap.set('n', '<leader>ll', function()
                        vim.cmd.edit(vim.lsp.get_log_path())
                    end, { buffer = event.buf, desc = "LSP: Open log" })
                    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<space>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<space>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end,
            })
        end)
        print("keybindings setup ok: " .. tostring(ok5) .. " " .. tostring(err5 or ""))

        print("=== LSP CONFIG DONE ===")
    end,
}
