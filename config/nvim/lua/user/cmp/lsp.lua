return function()
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
	require("user.cmp.handlersmason").setup()
end
