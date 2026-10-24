vim.loader.enable()
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Optional host providers we never use. Disabling them keeps `:checkhealth`
-- from reporting missing npm / Neovim::Ext / neovim-ruby-host packages.
-- (The Python 3 provider is kept enabled, pynvim is installed.)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.termguicolors = true

-- This config only uses lazy.nvim, never Neovim 0.12's built-in `vim.pack`.
-- But catppuccin probes `vim.pack.get()` while detecting installed plugins,
-- and that call *creates* `$XDG_DATA_HOME/nvim/site/pack/core/opt` as a side
-- effect. The leftover empty directory then makes `:checkhealth` report
--   WARNING found existing packages at `.../site/pack/core`
--   WARNING Lockfile is absent, plugin directory is present.
-- Skip the probe while `vim.pack` is unused; defer to the real thing otherwise.
if vim.pack and vim.pack.get then
	local pack_get = vim.pack.get
	vim.pack.get = function(...)
		local plug_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt")
		if vim.uv.fs_stat(plug_dir) == nil then
			return {}
		end
		return pack_get(...)
	end
end

-- Diagnostic gutter signs (same glyphs as the ones in `user.cmp.handlersmason`).
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})

require("user.lazy")
require("user.options")
require("user.keymaps")
