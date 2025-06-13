local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>dg', builtin.diagnostics,{} )
vim.keymap.set('n', '<leader>ps', function ()
	builtin.grep_string({search = vim.fn.input("Grep > ")})
end)


vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {})


