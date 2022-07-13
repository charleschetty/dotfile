local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here

	use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
	use({ "nvim-lua/popup.nvim" }) -- Have packer manage itself
	use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
	use({ "shaunsingh/nord.nvim" })
	use("windwp/nvim-autopairs")
	use({ "numToStr/Comment.nvim" }) -- Easily comment stuff  -- cmp plugins
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")
	use({
		"nvim-lualine/lualine.nvim"
	})
	use("ahmedkhalf/project.nvim")
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/indent-blankline.nvim")
  use 'goolord/alpha-nvim'
  use "antoinemadec/FixCursorHold.nvim" 
  use "folke/which-key.nvim"

	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-media-files.nvim")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("p00f/nvim-ts-rainbow")
	use("nvim-treesitter/playground")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	--     installer
	-- Automatically set up your configuration after cloning packer.nvim
  --
	-- Put this at the end after all plugins
	
  use 'CRAG666/code_runner.nvim'

  if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
