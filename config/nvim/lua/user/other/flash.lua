return function()
	vim.api.nvim_set_hl(0, "FlashMatch", {
		bg = "#a3be8c",
		fg = "#2e3440",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "FlashLabel", {
		bg = "#bf616a",
		fg = "#FFFFFF",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "FlashPrompt", {
		bg = "#eceff4",
		fg = "#b48ead",
		bold = true,
	})
	require("flash").setup({
		{
			-- options used when flash is activated through
			-- `f`, `F`, `t`, `T`, `;` and `,` motions
			char = {
				enabled = true,
				multi_line = false,
				search = { wrap = false },
				jump_labels = true,
				highlight = { backdrop = true, groups = { backdrop = "FlashLabel" } },
				jump = { register = false },
			},
		},
	})
end
