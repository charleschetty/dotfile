return function()
	--[[ require("guard").setup({ ]]
	--[[   -- the only options for the setup function ]]
	--[[   fmt_on_save = false, ]]
	--[[   -- Use lsp if no formatter was defined for this filetype ]]
	--[[   lsp_as_default_formatter = false, ]]
	--[[ }) ]]
	local ft_gu = require("guard.filetype")
	vim.g.guard_config = {
		-- format on write to buffer
		fmt_on_save = false,
		-- use lsp if no formatter was defined for this filetype
		lsp_as_default_formatter = false,
		-- whether or not to save the buffer after formatting
		save_on_fmt = false,
	}

	ft_gu("c")
		:fmt({
			cmd = "clang-format",
			args = { "--style=Google" },
			stdin = true,
		})
		:lint("clang-tidy")
	ft_gu("cpp")
		:fmt({
			cmd = "clang-format",
			args = { "--style=Google" },
			stdin = true,
		})
		:lint("clang-tidy")
	ft_gu("cuda"):fmt({
		cmd = "clang-format",
		args = { "--style=Microsoft" },
		stdin = true,
	})

	ft_gu("typescript,javascript,typescriptreact,markdown,html,json,jsonc,vue"):fmt("prettier")
	ft_gu("rust"):fmt("rustfmt")
	ft_gu("python"):fmt("ruff"):lint("ruff")
	ft_gu("lua"):fmt("stylua")
	ft_gu("bash"):fmt("shfmt")
	ft_gu("java"):fmt("google-java-format")

	ft_gu("go"):fmt("gofmt")


	ft_gu("zig"):fmt("zigfmt")
end
