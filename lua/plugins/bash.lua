return {
  -- This creates a simple script structure runner file to stand inside lazy.nvim scanning
  dir = "/home/thermodynamics/.config/nvim",
  virtual = true,
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'sh',
      callback = function()
        vim.lsp.start({
          name = 'bash-language-server',
          cmd = { 'bash-language-server', 'start' },
        })
      end,
    })
  end
}