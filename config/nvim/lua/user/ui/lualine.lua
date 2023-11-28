-- local status_ok, lualine = pcall(require, "lualine")
-- if not status_ok then
--   return
-- end
--
return function()
	local colors = {
		nord1 = "#3B4252",
		nord3 = "#4C566A",
		nord5 = "#E5E9F0",
		nord6 = "#ECEFF4",
		nord7 = "#8FBCBB",
		nord8 = "#88C0D0",
		nord13 = "#EBCB8B",
	}

	local nordic = {
		normal = {
			a = { fg = colors.nord1, bg = colors.nord8, gui = "bold" },
			b = { fg = colors.nord5, bg = colors.nord1 },
			c = { fg = colors.nord5, bg = colors.nord3 },
		},
		insert = { a = { fg = colors.nord1, bg = colors.nord6, gui = "bold" } },
		visual = { a = { fg = colors.nord1, bg = colors.nord7, gui = "bold" } },
		replace = { a = { fg = colors.nord1, bg = colors.nord13, gui = "bold" } },
		inactive = {
			a = { fg = colors.nord1, bg = colors.nord8, gui = "bold" },
			b = { fg = colors.nord5, bg = colors.nord1 },
			c = { fg = colors.nord5, bg = colors.nord1 },
		},
	}

	-- cool function for progress
	local progress = function()
		local current_line = vim.fn.line(".")
		local total_lines = vim.fn.line("$")
		local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
		local line_ratio = current_line / total_lines
		local index = math.ceil(line_ratio * #chars)
		return chars[index]
	end

	local spaces = function()
		return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
	end

	local opts = {
		options = {
			icons_enabled = true,
			--theme = 'auto',
			--[[ theme = nordic, ]]
			theme = "catppuccin",
    --[[ theme = 'onenord', ]]
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {},
			always_divide_middle = true,
			globalstatus = false,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		extensions = {},
	}
	require("lualine").setup(opts)
end
