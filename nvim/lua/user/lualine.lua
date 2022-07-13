local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

--local nordic = require'lualine.themes.nord'
local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local colors = {
  nord1  = '#3B4252',
  nord3  = '#4C566A',
  nord5  = '#E5E9F0',
  nord6  = '#ECEFF4',
  nord7  = '#8FBCBB',
  nord8  = '#88C0D0',
  nord13 = '#EBCB8B',
}

local nordic={
  normal = {
    a = { fg = colors.nord1, bg = colors.nord8, gui = 'bold' },
    b = { fg = colors.nord5, bg = colors.nord1 },
    c = { fg = colors.nord5, bg = colors.nord3 },
  },
  insert = { a = { fg = colors.nord1, bg = colors.nord6, gui = 'bold' } },
  visual = { a = { fg = colors.nord1, bg = colors.nord7, gui = 'bold' } },
  replace = { a = { fg = colors.nord1, bg = colors.nord13, gui = 'bold' } },
  inactive = {
    a = { fg = colors.nord1, bg = colors.nord8, gui = 'bold' },
    b = { fg = colors.nord5, bg = colors.nord1 },
    c = { fg = colors.nord5, bg = colors.nord1 },
  },
}


local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = true,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
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

-- lualine.setup({
-- 	options = {
-- 		icons_enabled = true,
-- 		theme = nordic,
-- 		component_separators = { left = "", right = "" },
-- 		section_separators = { left = "", right = "" },
-- 		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
-- 		always_divide_middle = true,
-- 	},
--
	-- sections = {
	-- 	lualine_a = { branch, diagnostics },
	-- 	lualine_b = { mode },
	-- 	lualine_c = {},
	-- 	-- lualine_x = { "encoding", "fileformat", "filetype" },
	-- 	lualine_x = { diff, spaces, "encoding", filetype },
	-- 	lualine_y = { location },
	-- 	lualine_z = { progress },
	-- },
-- 	inactive_sections = {
-- 		lualine_a = {},
-- 		lualine_b = {},
-- 		lualine_c = { "filename" },
-- 		lualine_x = { "location" },
-- 		lualine_y = {},
-- 		lualine_z = {},
-- 	},
-- 	tabline = {},
-- 	extensions = {},
-- })

require('lualine').setup {
  options = {
    icons_enabled = true,
    --theme = 'auto',
    theme = nordic,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
