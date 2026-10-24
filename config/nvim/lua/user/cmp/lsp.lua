return function()
	-- clangd: nvim-lspconfig still advertises the legacy `offsetEncoding`
	-- capability, which clangd >= 22 logs as a deprecation error on *every*
	-- start ("offsetEncoding capability is a deprecated clangd extension").
	-- Neovim already sends the standard `general.positionEncodings` capability,
	-- so just drop the legacy one before the initialize request is sent.
	vim.lsp.config("clangd", {
		before_init = function(params)
			if params.capabilities then
				params.capabilities.offsetEncoding = nil
			end
		end,
	})

	--[[ vim.lsp.enable("html") ]]
	vim.lsp.enable("clangd")
	--[[ vim.lsp.enable("cmake") ]]
	vim.lsp.enable("jdtls")
	vim.lsp.enable("lua_ls")
	vim.lsp.enable("marksman")
	vim.lsp.enable("pyright")
  vim.lsp.enable("r_language_server")
  --[[ vim.lsp.enable("cssls") ]]
  vim.lsp.enable("texlab")
  vim.lsp.enable("tinymist")
  vim.lsp.enable("ruff")
  vim.lsp.enable("gopls")
	vim.lsp.enable('zls')
	vim.lsp.enable('racket_langserver')
	--[[ vim.lsp.enable('leanls') ]]
	require("user.cmp.handlersmason").setup()
end
