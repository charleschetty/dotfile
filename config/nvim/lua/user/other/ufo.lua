return function()
	vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
	vim.o.foldcolumn = "1" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
  local language_servers = vim.lsp.get_clients()
	for _, ls in ipairs(language_servers) do
		require("lspconfig")[ls].setup({
			capabilities = capabilities,
			-- you can add other fields for setting up lsp server in this table
		})
	end
	require("ufo").setup()
	--[[ require("ufo").setup({ ]]
	--[[ 	provider_selector = function(bufnr, filetype, buftype) ]]
	--[[ 		return { "treesitter", "indent" } ]]
	--[[ 	end, ]]
	--[[ }) ]]
end
