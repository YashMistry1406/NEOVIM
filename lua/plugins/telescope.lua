return {
  "nvim-telescope/telescope.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim"
  },
  config = function()
    local builtin = require('telescope.builtin')
    
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
    vim.keymap.set('n', '<leader>dg', builtin.diagnostics, {})
    vim.keymap.set('n', '<leader>ps', function ()
      builtin.grep_string({search = vim.fn.input("Grep > ")})
    end)
    vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {})

    require('telescope').setup{
      defaults = {
        mappings = {
          i = { ["<M-d>"] = require('telescope.actions').delete_buffer },
          n = { ["<M-d>"] = require('telescope.actions').delete_buffer },
        },
      },
      extensions = {
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
        },
      },
    }

    vim.api.nvim_set_keymap(
        "n",
        "<space>fe",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { noremap = true }
    )
    require("telescope").load_extension "file_browser"
  end
}