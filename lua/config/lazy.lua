-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- We explicitly define the plugins here so lazy installs them,
    -- completely avoiding the automatic folder scan crash.
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "folke/trouble.nvim" },
    { "windwp/nvim-autopairs" },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    { "olimorris/onedarkpro.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-tree/nvim-tree.lua" },
    { "rmagatti/auto-session" },
    { "mfussenegger/nvim-jdtls" },
    {import = "plugins"}
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})