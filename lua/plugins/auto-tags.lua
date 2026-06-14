return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensures treesitter loads first
  config = function()
    local status, autotag = pcall(require, "nvim-ts-autotag")
    if not status then return end

    autotag.setup({})
  end,
}
