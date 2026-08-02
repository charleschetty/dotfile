if vim.fn.executable("racket") == 1 then
	local ok, _opts = pcall(require, "user.configs.lsp-servers.racket_langserver")
	if not ok then
		_opts = require("completion.servers.racket_langserver")
	end
	local opts = {
		capabilities = require("modules.utils").get_lsp_capabilities(),
	}
	local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
	require("modules.utils").register_server("racket_langserver", final_opts)
end
