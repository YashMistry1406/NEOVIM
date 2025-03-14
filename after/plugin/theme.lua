require("onedarkpro").setup({
colors = {
    onedark_dark = { bg = "#000000" }, -- yellow
    light = { bg = "#00FF00" }, -- green
  },
    options = {
    cursorline = true, -- Use cursorline highlighting?
    transparency = true, -- Use a transparent background?
    terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
    lualine_transparency = false, -- Center bar transparency?
    highlight_inactive_windows = false, -- When the window is out of focus, change the normal background?
  }
})

--vim.cmd("colorscheme onedark_dark")
--require("monokai-pro").setup({
--
--    filter = "ristretto"
--})
--vim.cmd([[colorscheme monokai-pro-ristretto]])
--
--Lua:
--vim.cmd 'colorscheme material'

require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
    italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },

  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = true,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
      ["@comment"] = { fg = "#b3b0af" },
  },
  dim_inactive = false,
  transparent_mode = true,
})
vim.cmd("colorscheme gruvbox")
