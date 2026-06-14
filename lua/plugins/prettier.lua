return {
  "prettier/vim-prettier",
  build = "npm install -g prettier",
  ft = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  config = function()
    -- This matches your absolute execution spec requirements safely
    vim.g["prettier#exec_cmd_path"] = "prettier"
  end
}