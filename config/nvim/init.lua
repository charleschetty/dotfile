vim.loader.enable()
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true


vim.diagnostic.config({
	signs = { text = { [vim.diagnostic.severity.WARN] = "cahac", ... } },
})

require("user.lazy")
require("user.options")
require("user.keymaps")
