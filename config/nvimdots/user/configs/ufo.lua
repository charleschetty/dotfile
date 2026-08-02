local M = {}

M.setup = function()
	vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
	vim.o.foldcolumn = "1"
	vim.o.foldlevel = 99
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true

	require("ufo").setup({
		provider_selector = function()
			return { "treesitter", "indent" }
		end,
	})
end

return M.setup