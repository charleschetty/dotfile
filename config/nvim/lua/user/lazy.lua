local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	------------------------------ ui ------------------------------
	--[[ { ]]
	--[[ 	"shaunsingh/nord.nvim", ]]
	--[[ 	priority = 1000, ]]
	--[[    lazy = true, ]]
	--[[ 	config = require("user.ui.nordic"), ]]
	--[[ }, ]]
	--[[ { ]]
	--[[ 	"rmehri01/onenord.nvim", ]]
	--[[ 	init = function() ]]
	--[[ 		vim.cmd.colorscheme("onenord") ]]
	--[[ 	end, ]]
	--[[ 	priority = 1000, ]]
	--[[ }, ]]
	{
		"catppuccin/nvim",
		name = "catppuccin",
		--[[ lazy = true, ]]
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("catppuccin-frappe")
		end,
		config = require("user.ui.catppuccin"),
	},
	--[[ { "EdenEast/nightfox.nvim" }, -- lazy ]]
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		lazy = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("user.ui.alpha"),
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		lazy = true,
		--[[ after = "catppuccin", ]]
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		dependencies = { "nvim-tree/nvim-web-devicons", "shaunsingh/nord.nvim" },
		config = require("user.ui.bufferline"),
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		lazy = true,
		main = "ibl",
		event = { "CursorHold", "CursorHoldI" },
		config = require("user.ui.indentline"),
	},

	{
		"nvim-lualine/lualine.nvim",
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = require("user.ui.lualine"),
	},

	------------------------------ tool ------------------------------

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = true,
		cmd = {
			"NvimTreeToggle",
			"NvimTreeOpen",
			"NvimTreeFindFile",
			"NvimTreeFindFileToggle",
			"NvimTreeRefresh",
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = require("user.tool.nvim-tree"),
	},

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>t",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},

	--[[ { ]]
	--[[ 	"folke/which-key.nvim", ]]
	--[[ 	lazy = true, ]]
	--[[ 	event = { "CursorHold", "CursorHoldI" }, ]]
	--[[ 	init = function() ]]
	--[[ 		vim.o.timeout = true ]]
	--[[ 		vim.o.timeoutlen = 300 ]]
	--[[ 	end, ]]
	--[[ 	config = require("user.tool.whichkey"), ]]
	--[[ }, ]]
	--[[]]
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = require("user.tool.whichkey"),
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"gelguy/wilder.nvim",
		lazy = true,
		event = "CmdlineEnter",
		build = ":UpdateRemotePlugins",
		dependencies = { "romgrk/fzy-lua-native" },
		config = require("user.tool.wilder"),
	},

	------------------------------ telescope ------------------------------
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		cmd = "Telescope",
		config = require("user.tool.telescope"),
		dependencies = {
			{ "rafi/telescope-thesaurus.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
			"nvim-telescope/telescope-media-files.nvim",
		},
	},

	"nvim-telescope/telescope-ui-select.nvim",

	------------------------------ dap ------------------------------
	---
	--todo

	{

		"mfussenegger/nvim-dap",
		lazy = true,
		cmd = {
			"DapSetLogLevel",
			"DapShowLog",
			"DapContinue",
			"DapToggleBreakpoint",
			"DapToggleRepl",
			"DapStepOver",
			"DapStepInto",
			"DapStepOut",
			"DapTerminate",
		},
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = {
					"nvim-neotest/nvim-nio",
				},
				config = require("user.dap.dapui"),
			},
			"theHamsta/nvim-dap-virtual-text",
		},
		config = require("user.dap.dap"),
	},

	------------------------------ lang ------------------------------
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		--[[ config = require("user.lang.rt"), ]]
	},
	{

		"MeanderingProgrammer/render-markdown.nvim",
		lazy = true,
		ft = "markdown",
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	},

	{
		"3rd/image.nvim",
		lazy = true,
		ft = "markdown",
		config = require("user.lang.image"),
		opts = {},
	},

	--[[ { ]]
	--[[ 	url = "https://git.sr.ht/~p00f/clangd_extensions.nvim", ]]
	--[[ 	lazy = true, ]]
	--[[ 	ft = { "cpp", "c", "cuda" }, ]]
	--[[ }, ]]
	--[[ { ]]
	--[[ 	"ranjithshegde/ccls.nvim", ]]
	--[[ 	lazy = true, ]]
	--[[ 	ft = {"cpp" , "c" , "cuda"}, ]]
	--[[ }, ]]

	--[[ { ]]
	--[[ 	"nvim-neorg/neorg", ]]
	--[[ 	lazy = true, ]]
	--[[ 	ft = "norg", ]]
	--[[ 	build = ":Neorg sync-parsers", ]]
	--[[ 	dependencies = { "nvim-lua/plenary.nvim" }, ]]
	--[[ 	config = function() ]]
	--[[ 		require("neorg").setup({ ]]
	--[[ 			load = { ]]
	--[[ 				["core.defaults"] = {}, -- Loads default behaviour ]]
	--[[ 				["core.concealer"] = {}, -- Adds pretty icons to your documents ]]
	--[[ 				["core.completion"] = { ]]
	--[[ 					config = { ]]
	--[[ 						engine = "nvim-cmp", ]]
	--[[ 					}, ]]
	--[[ 				}, ]]
	--[[ 			}, ]]
	--[[ 		}) ]]
	--[[ 	end, ]]
	--[[ }, ]]

	{
		"kaarmu/typst.vim",
		ft = "typst",
		lazy = true,
	},

	--[[ { ]]
	--[[   "toppair/peek.nvim", ]]
	--[[   event = { "VeryLazy" }, ]]
	--[[   build = "deno task --quiet build:fast", ]]
	--[[   config = function() ]]
	--[[     require("peek").setup() ]]
	--[[     -- refer to `configuration to change defaults` ]]
	--[[     vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {}) ]]
	--[[     vim.api.nvim_create_user_command("PeekClose", require("peek").close, {}) ]]
	--[[   end, ]]
	--[[ }, ]]

	------------------------------ editor ------------------------------
	{
		"LunarVim/bigfile.nvim",
		lazy = false,
	},

	{
		"ojroques/nvim-bufdel",
		lazy = true,
		cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
	},

	{
		"numToStr/Comment.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = require("user.editor.comment"),
	},

	{
		"RRethy/vim-illuminate",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = require("user.editor.illuminate"),
	},

	------------------------------ treesitter ------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			if #vim.api.nvim_list_uis() ~= 0 then
				vim.api.nvim_command("TSUpdate")
			end
		end,
		lazy = true,
		event = "BufReadPost",
		config = require("user.editor.treesitter"),
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{
				"andymass/vim-matchup",
				init = function()
					vim.g.matchup_matchparen_offscreen = { method = "popup" }
				end,
			},
			{
				"catgoose/nvim-colorizer.lua",
				config = require("user.editor.colorsizer"),
			},
		},
	},
	------------------------------ cmp ------------------------------

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		--[[ opts = {} -- this is equalent to setup({}) function ]]
		config = require("user.cmp.autopairs"),
	},

	{
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = require("user.cmp.lsp"),
		dependencies = {
			{
				"ray-x/lsp_signature.nvim",
				config = require("user.cmp.lsp-sign"),
			},
		},
	},

	{
		"nvimdev/lspsaga.nvim",
		lazy = false,
		event = "LspAttach",
		config = require("user.cmp.lspsaga"),
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},

	{
		"nvimdev/guard.nvim",
		dependencies = {
			"nvimdev/guard-collection",
		},
		lazy = true,
		cmd = {
			"Guard",
		},
		config = require("user.cmp.guard"),
	},

	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = "InsertEnter",
		config = require("user.cmp.cmp"),
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = require("user.cmp.luasnip"),
			},
			{ "lukas-reineke/cmp-under-comparator" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-path" },
			{ "f3fora/cmp-spell" },
			{ "hrsh7th/cmp-buffer" },
			{ "kdheepak/cmp-latex-symbols" },
			{ "ray-x/cmp-treesitter", commit = "c8e3a74" },
		},
	},

	------------------------------ other ------------------------------

	{
		"kevinhwang91/nvim-hlslens",
		lazy = false,
		config = require("user.other.hlslen"),
	},
	--[[ 'nacro90/numb.nvim', ]]
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = require("user.other.flash"),
		opts = {},
		keys = {},
	},

	{
		"chrisgrieser/nvim-spider",
		lazy = true,
		init = function()
			vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
			vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
			vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
			vim.keymap.set(
				{ "n", "o", "x" },
				"ge",
				"<cmd>lua require('spider').motion('ge')<CR>",
				{ desc = "Spider-ge" }
			)
		end,
	},

	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
					{ text = { " ", builtin.foldfunc, " " }, click = "v:lua.ScFa" },
				},
			})
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "VeryLazy",
		config = require("user.other.ufo"),
	},
})
