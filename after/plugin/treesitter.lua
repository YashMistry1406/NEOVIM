require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {"javascript","typescript","rust","java","python" ,"lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  statusline = {

    indicator_size = 100,
    type_patterns = {'class', 'function', 'method'},
    transform_fn = function(line, _node) return line:gsub('%s*[%[%(%{]*%s*$', '') end,
    separator = ' -> ',
    allow_duplicates = false
  },

}

local ts_utils = require('nvim-treesitter.ts_utils')
local M = {}
-- Function to get the current function name under the cursor
function M.get_current_function_name()
  -- Get the node under the cursor
  local current_node = ts_utils.get_node_at_cursor()

  -- If no node is found, return an empty string
  if not current_node then
    return ""
  end
while current_node do
    -- If the current node is a function_declaration or similar
    if current_node:type() == 'function_declaration' then
      -- Get the first child node, which is usually the function name
      local func_name_node = current_node:child(1)
      -- Return the function name text
      return vim.treesitter.get_node_text(func_name_node, 0)
    end

    -- Move to the parent node (for cases like inside a function call)
    current_node = current_node:parent()
  end

  -- Return an empty string if no function declaration node is found
  return ""
end
return M
