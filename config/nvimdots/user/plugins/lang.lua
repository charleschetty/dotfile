local lang = {}

lang["Julian/lean.nvim"] = {
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"andymass/vim-matchup",
	},
	init = function()
		vim.g.lean_config = {
			mappings = true,
		}
	end,
}

lang["kaarmu/typst.vim"] = {
	lazy = true,
	ft = "typst",
}

return lang
