--local home = vim.fn.getenv("HOME")
--local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
--local jdtls = require('jdtls')
--
--local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
--local root_dir = require('jdtls.setup').find_root(root_markers)
--
--
--
--local on_attach = function(client, bufnr)
--  -- Regular Neovim LSP client keymappings
--  local bufopts = { noremap=true, silent=true, buffer=bufnr }
-- vim.keymap.set('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
--   { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
-- nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")
--
--  -- Java extensions provided by jdtls
--  nnoremap("<space>co", jdtls.organize_imports(), bufopts, "Organize imports")
--  nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
--  nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
--  vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
--    { noremap=true, silent=true, buffer=bufnr, desc = "Extract method" })
--end
--
--
--
--local workspace_dir = home .. '/java/'
--local config = {
--    
--    settings = {
--    java = {
--      format = {
--        settings = {
--          url = vim.fn.expand("~/.config/java/eclipse-java-formatter.xml"),
--          profile = "Custom",
--        },
--      },
--    },
--  },
--    root_dir = root_dir,
--    on_attach=on_attach,
--    cmd = {
--        "java" ,
--	'-Declipse.application=org.eclipse.jdt.ls.core.id1',
--	'-Dosgi.bundles.defaultStartLevel=4',
--	'-Declipse.product=org.eclipse.jdt.ls.core.product ',
--	'-Dlog.level=ALL ',
--	'-noverify',
--	'-Xmx1G',
--    "--add-opens",
--    "java.base/java.util=ALL-UNNAMED",
--    "--add-opens",
--    "java.base/java.lang=ALL-UNNAMED",
--    '-javaagent:' .. home .. '~/.local/share/nvim/mason/packages/jdtls/lombok.jar',
--	--add-modules=ALL-SYSTEM \
----	'-jar', '/home/thermodynamics/Downloads/nvim/jdt-language-server-1.20.0-202302201605/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
----	'-configuration', '/home/thermodynamics/Downloads/nvim/jdt-language-server-1.20.0-202302201605/config_linux/',
--    '-jar','/home/thermodynamics/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
--    '-configuration' , '~/.local/share/nvim/mason/packages/jdtls/config_linux/',
--	'-data', workspace_dir .. project_name
--},
--
--}
--    --root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
--require('jdtls').start_or_attach(config)

local jdtls = require("jdtls")
local home = vim.env.HOME

-- Detect project root
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == nil then
  return
end

-- Workspace directory (per project)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. project_name

-- on_attach: keymaps + formatting
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Format
  vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend("force", opts, { desc = "Format file" }))

  -- Code actions
  vim.keymap.set("v", "<space>ca", function()
    vim.lsp.buf.range_code_action()
  end, vim.tbl_extend("force", opts, { desc = "Code actions" }))

  -- jdtls extras
  vim.keymap.set("n", "<space>co", jdtls.organize_imports,
    vim.tbl_extend("force", opts, { desc = "Organize imports" }))

  vim.keymap.set("n", "<space>ev", jdtls.extract_variable,
    vim.tbl_extend("force", opts, { desc = "Extract variable" }))

  vim.keymap.set("n", "<space>ec", jdtls.extract_constant,
    vim.tbl_extend("force", opts, { desc = "Extract constant" }))

  vim.keymap.set("v", "<space>em", function()
    jdtls.extract_method(true)
  end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
end

-- JDTLS command
local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.level=ALL",
  "-Xmx1G",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
  "-jar", home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
  "-configuration", home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
  "-data", workspace_dir,
}

-- Final config
local config = {
  cmd = cmd,
  root_dir = root_dir,
  on_attach = on_attach,

  settings = {
    java = {
      format = {
        settings = {
          url = home .. "/.config/java/eclipse-java-formatter.xml",
          profile = "Custom",
        },
      },
    },
  },

  init_options = {
    bundles = {},
  },
}

-- Start or attach
jdtls.start_or_attach(config)

-- Format on save (Java only)
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

