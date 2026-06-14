require("yash")
require("config.lazy")

-- -- Automatically look inside lua/plugins/ and require every file dynamically
-- local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins/"
-- local handle = vim.loop.fs_scandir(plugins_dir)
--
-- if handle then
--   while true do
--     local name, type = vim.loop.fs_scandir_next(handle)
--     if not name then break end
--
--     -- Find every .lua configuration file and run it
--     if type == "file" and name:match("%.lua$") then
--       local module_name = "plugins." .. name:gsub("%.lua$", "")
--       require(module_name)
--     end
--   end
-- end
