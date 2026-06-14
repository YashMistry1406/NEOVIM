return {
  { "olimorris/onedarkpro.nvim", priority = 1000 },
  { 
    "ellisonleao/gruvbox.nvim", 
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        colors = {
          onedark_dark = { bg = "#000000" },
          light = { bg = "#00FF00" },
        },
        options = {
          cursorline = true,
          transparency = true,
          terminal_colors = true,
          lualine_transparency = false,
          highlight_inactive_windows = false,
        }
      })

      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = { strings = true, comments = true, operators = false, folds = true },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = true,
        invert_intend_guides = false,
        inverse = true,
        contrast = "hard",
        palette_overrides = {},
        overrides = {
            ["@comment"] = { fg = "#b3b0af" },
        },
        dim_inactive = false,
        transparent_mode = true,
      })
      
      vim.cmd("colorscheme gruvbox")
    end
  }
}