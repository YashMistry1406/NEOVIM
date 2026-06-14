return {
  "rmagatti/auto-session",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Requires telescope to show the layout view
  },
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      log_level = "error",
      auto_session_enable_cmdline_autosave = true,
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      
      -- Enable and configure the session viewer view
      session_lens = {
        picker="telescope",
        load_on_setup = true, -- Automatically load the telescope extension
        theme_conf = { border = true },
        previewer = false,    -- Hides the massive empty file preview pane for a cleaner list view
      },
    })

    -- 1. Map your custom view overlay to a clean shortcut: <space>sl (Session Lens)
    vim.keymap.set("n", "<space>sl", "<cmd>Telescope session-lens search_session<CR>", {
      noremap = true,
      silent = true,
      desc = "View and search saved sessions"
    })

    -- 2. Your existing individual restore map
    vim.keymap.set("n", "<space>wr", "<cmd>AutoSession search<CR>", { 
      noremap = true, 
      silent = true, 
      desc = "Restore session for current directory" 
    })

    -- 3. Your existing individual manual save map
    vim.keymap.set("n", "<space>ws", "<cmd>AutoSession save<CR>", { 
      noremap = true, 
      silent = true, 
      desc = "Save session manually" 
    })
  end
}