-- smart-splits.nvim v3 配置覆盖。
--
-- modules 层（lua/modules/configs/ui/splits.lua）还是 v2 写法：
--     default_amount = 3
-- v3 已把它改名为 `resize.amount`，于是每次加载插件都会弹：
--     [smart-splits.nvim] problems in your config, see :checkhealth smart-splits
--       `default_amount` moved to `resize.amount`
--
-- 注意：这里必须返回 function。返回 table 会走 tbl_recursive_merge（只增不改删），
-- 旧的 `default_amount` 会残留，警告依旧；返回 function 才是整体替换。
return function()
	return {
		-- 原来 default_amount = 3（每次 resize 的列/行数）
		resize = {
			amount = 3,
		},
		ignored_buftypes = { "nofile", "quickfix", "prompt" },
		ignored_filetypes = { "NvimTree" },
	}
end
