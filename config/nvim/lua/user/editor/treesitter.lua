return function()
	local configs = require("nvim-treesitter.configs")
	configs.setup({
		ensure_installed = {
			"bash",
			"bibtex",
			"c",
			"cpp",
			"cmake",
			"commonlisp",
			"css",
			"cuda",
			"go",
			"gomod",
			"html",
			"haskell",
			"javascript",
			"java",
			"json",
			"latex",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"r",
			"typescript",
			"vimdoc",
			"vim",
			"vue",
			"yaml",
		},

		--[[ ensure_installed = "maintained", ]]
		--  ensure_installed = "maintained",
		sync_install = true,
		ignore_install = { "" }, -- List of parsers to ignore installing
		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "typst" }, -- list of language that will be disabled
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true, disable = { "yaml" } },
		matchup = {
			enable = true, -- mandatory, false will disable the whole extension
			--[[ disable = { "c", "ruby" },  -- optional, list of language that will be disabled ]]
			-- [options]
		},
	})
end
