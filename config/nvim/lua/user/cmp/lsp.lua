return function()
	local util = require("lspconfig/util")

	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	require("lspconfig").html.setup({})
	require("user.cmp.handlersmason").setup()
	require("lspconfig").clangd.setup({
	})
	--[[ require("lspconfig").ccls.setup({}) ]]
	require("lspconfig").cmake.setup({})
	require("lspconfig").jdtls.setup({})
	--[[ require 'lspconfig'.jedi_language_server.setup {} ]]
	require("lspconfig").lua_ls.setup({})
	require("lspconfig").marksman.setup({})
	require("lspconfig").pyright.setup({})
	--[[ require("lspconfig").jedi_language_server.setup({}) ]]
	--[[ require 'lspconfig'.pylsp.setup {} ]]
	require("lspconfig").r_language_server.setup({})
	require("lspconfig").cssls.setup({

		single_file_support = true,
	})
	require("lspconfig").texlab.setup({
		--[[ cmd = { "/home/charles/SourceFile/bin/texlab" }, ]]
	})

	require("lspconfig").grammarly.setup({
		cmd = { "grammarly-languageserver", "--stdio" },
		filetypes = { "tex", "markdown", "text" },
		init_options = {
			clientId = "client_BaDkMgx4X19X9UxxYRCXZo",
		},
		single_file_support = true,
		root_dir = util.find_git_ancestor,
	})

	require("lspconfig").typst_lsp.setup({
		--[[ cmd = { "~/SourceFile/bin/typst-lsp" }, ]]
		filetypes = { "typst" },
		single_file_support = true,
		root_dir = util.find_git_ancestor,
	})
	require("lspconfig").rust_analyzer.setup({
		--[[ cmd = { 'rustup run stable rust-analyzer' }, ]]
	})

	require("lspconfig").ruff_lsp.setup({
		init_options = {
			settings = {
				-- Any extra CLI arguments for `ruff` go here.
				args = {},
			},
		},
	})

  require'lspconfig'.r_language_server.setup{}
end
