return function()
	require("catppuccin").setup({
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			treesitter_context = false,
			notify = false,
			alpha = true,
			flash = true,
			lsp_saga = false,
			indent_blankline = {
				enabled = true,
				scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
				colored_indent_levels = false,
			},
			which_key = false,
			lsp_trouble = false,
			telescope = {
				enabled = true,
				-- style = "nvchad"
			},
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			ufo = true,
		},
	})
end
