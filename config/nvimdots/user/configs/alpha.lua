return function(opts)
	local dashboard = require("alpha.themes.dashboard")
	local header = vim.fn.systemlist(
		"onefetch 2>/dev/null | sed 's/\\x1b\\[[0-9;?]*[a-zA-Z]//g'"
	)
	if #header > 0 then
		dashboard.section.header.val = header
	else
		dashboard.section.header.val = {
			[[▄▄                   ]],
			[[▀███▄   ▀███▀                ▀████▀   ▀███▀ ██                   ]],
			[[  ███▄    █                    ▀██     ▄█                        ]],
			[[  █ ███   █   ▄▄█▀██  ▄██▀██▄   ██▄   ▄█  ▀███ ▀████████▄█████▄  ]],
			[[  █  ▀██▄ █  ▄█▀   ████▀   ▀██   ██▄  █▀    ██   ██    ██    ██  ]],
			[[  █   ▀██▄█  ██▀▀▀▀▀▀██     ██   ▀██ █▀     ██   ██    ██    ██  ]],
			[[  █     ███  ██▄    ▄██▄   ▄██    ▄██▄      ██   ██    ██    ██  ]],
			[[▄███▄    ██   ▀█████▀ ▀█████▀      ██     ▄████▄████  ████  ████▄  ]],
		}
	end
	return opts
end
