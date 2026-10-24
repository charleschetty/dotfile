-- Neovim 0.12 兼容垫片。
--
-- 目的：让还没适配 0.12 新签名的第三方插件不再往消息区刷 deprecation 告警，
-- 行为与旧版保持一致（新签名调用完全透传，不受影响）。
--
-- 目前有两处来源（都很“吵”，每次补全都会触发）：
--   1) blink.compat 故意使用旧式 `vim.str_utfindex(s, index)`（为了和 nvim-cmp 行为一致，
--      见 saghen/blink.compat commit 1c44e7e）。nvimdots 用它桥接 nvim-cmp 的
--      spell / tmux / latex_symbols 源，于是每次补全都报：
--        vim.str_utfindex is deprecated. Run ":checkhealth vim.deprecated" ...
--   2) cmp-latex-symbols 仍在使用旧式 `vim.validate{ ... }` 表格式，每次补全报：
--        vim.validate{<table>} is deprecated. ...
--
-- 插件升级修好之后，这个文件可以整块删掉。

-- 1) 旧式 vim.str_utfindex(s, index) -> 底层实现（返回值与旧 API 完全一致）
local str_utfindex_new = vim.str_utfindex
local str_utfindex_legacy = vim._str_utfindex
if str_utfindex_new and str_utfindex_legacy then
	vim.str_utfindex = function(s, encoding, index, strict_indexing)
		if encoding == nil or type(encoding) == "number" then
			local col32, col16 = str_utfindex_legacy(s, encoding)
			if not col32 or not col16 then
				error("index out of range")
			end
			return col32, col16
		end
		return str_utfindex_new(s, encoding, index, strict_indexing)
	end
end

-- 2) 旧式 vim.validate{ name = { value, validator, optional_or_message } }
local validate_new = vim.validate
if validate_new then
	vim.validate = function(name, value, validator, optional, message)
		if type(name) == "table" and value == nil and validator == nil then
			for param_name, spec in pairs(name) do
				local param_value, param_validator, extra = spec[1], spec[2], spec[3]
				if type(extra) == "boolean" then
					validate_new(param_name, param_value, param_validator, extra)
				else
					validate_new(param_name, param_value, param_validator, nil, extra)
				end
			end
			return
		end
		return validate_new(name, value, validator, optional, message)
	end
end
