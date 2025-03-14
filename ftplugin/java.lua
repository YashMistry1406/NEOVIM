local home = vim.fn.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local jdtls = require('jdtls')

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require('jdtls.setup').find_root(root_markers)



local on_attach = function(client, bufnr)
  -- Regular Neovim LSP client keymappings
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
 vim.keymap.set('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
   { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
 nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")

  -- Java extensions provided by jdtls
  nnoremap("<space>co", jdtls.organize_imports(), bufopts, "Organize imports")
  nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
  nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
  vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap=true, silent=true, buffer=bufnr, desc = "Extract method" })
end



local workspace_dir = home .. '/java/'
local config = {
    
    root_dir = root_dir,
    on_attach=on_attach,
    cmd = {
        "java" ,
	'-Declipse.application=org.eclipse.jdt.ls.core.id1',
	'-Dosgi.bundles.defaultStartLevel=4',
	'-Declipse.product=org.eclipse.jdt.ls.core.product ',
	'-Dlog.level=ALL ',
	'-noverify',
	'-Xmx1G',
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    '-javaagent:' .. home .. '~/.local/share/nvim/mason/packages/jdtls/lombok.jar',
	--add-modules=ALL-SYSTEM \
--	'-jar', '/home/thermodynamics/Downloads/nvim/jdt-language-server-1.20.0-202302201605/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
--	'-configuration', '/home/thermodynamics/Downloads/nvim/jdt-language-server-1.20.0-202302201605/config_linux/',
    '-jar','~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
    '-configuration' , '~/.local/share/nvim/mason/packages/jdtls/config_linux/',
	'-data', workspace_dir .. project_name
},

}
    --root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
require('jdtls').start_or_attach(config)
