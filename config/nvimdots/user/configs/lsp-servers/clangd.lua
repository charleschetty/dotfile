-- clangd 的用户级覆盖（user 层，不改 modules 默认配置）。
--
-- 背景：
--   * modules 里的 clangd cmd 用了 `--function-arg-placeholders`（不带值），
--     clangd 22/23 会直接报：
--       E[...] Value specified by --function-arg-placeholders is invalid.
--   * modules 里还传了旧式 `offsetEncoding` 能力，clangd >= 22 每次启动都报：
--       E[...] offsetEncoding capability is a deprecated clangd extension ...
--     Neovim 0.11+ 已默认发送标准 `general.positionEncodings`，不需要它。
--   * 另外希望 clangd 也服务 Ascend C（.asc 已映射为 cpp）。
--
-- 做法：先跑一遍 modules 的 clangd 配置（保留其中的 on_attach 命令等），
-- 再把这两处有问题的字段改掉。
local base_clangd = require("completion.servers.clangd")

---@param defaults table 框架传入的默认 capabilities 等
return function(defaults)
	base_clangd(defaults)

	local resolved = vim.lsp.config["clangd"] or {}
	local cmd = vim.deepcopy(resolved.cmd or { "clangd" })
	for i, arg in ipairs(cmd) do
		if arg == "--function-arg-placeholders" then
			cmd[i] = "--function-arg-placeholders=true"
		end
	end

	vim.lsp.config("clangd", {
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "asc" },
		cmd = cmd,
		before_init = function(params)
			if params.capabilities then
				params.capabilities.offsetEncoding = nil
			end
		end,
	})
end
