return function(opts)
	local dashboard = require("alpha.themes.dashboard")
	dashboard.section.header.val = vim.fn.systemlist(
		"onefetch 2>/dev/null | sed 's/\\x1b\\[[0-9;?]*[a-zA-Z]//g'"
	)
	if #dashboard.section.header.val == 0 then
		dashboard.section.header.val = require("core.settings").dashboard_image
	end
	return opts
end
