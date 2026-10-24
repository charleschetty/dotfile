-- Ascend C (.asc): 映射为 cpp filetype，使 clangd 可识别
-- 编译参数由项目根 compile_commands.json 提供（参考 ~/.lib/cann/gen_compile_commands.sh）
vim.filetype.add({
	extension = {
		asc = "cpp",
	},
})

-- NOTE: clangd 的 cmd / offsetEncoding 修补在 `user.configs.lsp-servers.clangd`，
-- 那样才能在 server 启动前生效（放在这里时机太晚，首个 buffer 仍会用旧参数）。

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
