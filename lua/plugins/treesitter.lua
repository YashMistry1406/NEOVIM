return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Safe guard: Check if the plugin is actually downloaded and ready on disk
    local status, configs = pcall(require, "nvim-treesitter.configs")
    if not status then 
      -- Fail silently during the download phase so it doesn't brick your startup
      return 
    end

    configs.setup({
      ensure_installed = { "javascript", "typescript", "rust", "java", "python", "lua", "vim", "vimdoc", "query" },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      statusline = {
        indicator_size = 100,
        type_patterns = { "class", "function", "method" },
        transform_fn = function(line, _node)
          return line:gsub("%s*[%[%(%{]*%s*$", "")
        end,
        separator = " -> ",
        allow_duplicates = false,
      },
    })

    -- Safe call for the utilities module as well
    local ts_utils_status, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
    if not ts_utils_status then return end

    -- Define global function for your statusline component mapping
    _G.get_current_function_name = function()
      local current_node = ts_utils.get_node_at_cursor()
      if not current_node then
        return ""
      end

      while current_node do
        if current_node:type() == "function_declaration" then
          local func_name_node = current_node:child(1)
          return vim.treesitter.get_node_text(func_name_node, 0)
        end
        current_node = current_node:parent()
      end

      return ""
    end
  end,
}