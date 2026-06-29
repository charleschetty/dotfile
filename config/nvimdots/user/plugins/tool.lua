local tool = {}

tool["nvim-telescope/telescope-ui-select.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("telescope").load_extension("ui-select")
	end,
}

tool["nvim-telescope/telescope.nvim"] = {
	dependencies = {
		{ "rafi/telescope-thesaurus.nvim" },
		{ "nvim-telescope/telescope-media-files.nvim" },
	},
}

return tool
