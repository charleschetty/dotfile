return function()
	local wk = require("which-key")
	wk.add({

		{
			"<leader>f",
			"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
			mode = "n",
			desc = "find file",
		},
		{ "<c-t>", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "live grep" },
		{ "<leader>e", ":NvimTreeToggle<cr>", mode = "n", desc = "Explorer" },

		{ "<leader>/", "<Plug>(comment_toggle_linewise_current)", mode = "n", desc = "Comment" },
		{ "<leader>/", "<Plug>(comment_toggle_linewise_visual)", mode = "v", desc = "Comment" },
		{ "<leader>a", " <cmd>Alpha<cr>", mode = "n", desc = "Alpha" },
		{
			"<leader>b",
			"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			mode = "n",
			desc = "find buffers",
		},
		{ "<leader>c", "<cmd>BufDel<CR>", mode = "n", desc = "Close Buffer" },
		{ "<leader>w", "<cmd>w!<CR>", mode = "n", desc = "Save" },
		{ "<leader>q", "<cmd>q!<CR>", mode = "n", desc = "Quit" },
		{ "<leader>h", "<cmd>nohlsearch<CR>", mode = "n", desc = "No Highlight" },
		{ "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", mode = "n", desc = "Find Text" },
		{ "<leader>P", "<cmd>Telescope projects<cr>", mode = "n", desc = "Projects" },

		{ "<leader>p", group = "Lazy" }, -- group
		{ "<leader>pc", "<cmd>Lazy clean<cr>", mode = "n", desc = "clean" },
		{ "<leader>ps", "<cmd>Lazy sync<cr>", mode = "n", desc = "sync" },
		{ "<leader>pS", "<cmd>Lazy show<cr>", mode = "n", desc = "show" },

		{ "<leader>l", group = "lsp" }, -- group
		{ "<leader>la", "<cmd>Lspsaga code_action<CR>", mode = "n", desc = "Code Action" },
		{ "<leader>ld", "<cmd>Lspsaga show_buf_diagnostics<CR>", mode = "n", desc = "Document Diagnostics" },
		{ "<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", mode = "n", desc = "Workspace Diagnostics" },
		{ "<leader>li", "<cmd>LspInfo<CR>", mode = "n", desc = " Info" },
		{ "<leader>lf", "<cmd>Lspsaga finder def+ref<CR>", mode = "n", desc = "finder" },
		{ "<leader>lI", "<cmd>LspInstallInfo<CR>", mode = "n", desc = "Installer Info" },
		{ "<leader>lj", "<cmd>Lspsaga diagnostic_jump_next<CR>", mode = "n", desc = "Next Diagnostic" },
		{ "<leader>lk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", mode = "n", desc = "Prev Diagnostic" },
		{ "<leader>lr", "<cmd>Lspsaga rename<CR>", mode = "n", desc = "Rename" },
		{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", mode = "n", desc = "Document Symbols" },
		{ "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", mode = "n", desc = "Workspace Symbols" },

		{ "<leader>d", group = "dap" }, -- group
		{
			"<Leader>db",
			"<Cmd>lua require('dap').toggle_breakpoint()<CR>",
			mode = "n",
			desc = "toggle_breakpoint",
			{ noremap = true, silent = true },
		},
		{
			"<Leader>dc",
			"<Cmd>lua require('dap').continue()<CR>",
			mode = "n",
			desc = "continue",
			{ noremap = true, silent = true },
		},
		{
			"<Leader>dr",
			"<Cmd>lua require('dap').repl.toggle({height = math.floor(vim.o.lines / 3)})<CR>",
			mode = "n",
			desc = "repl toogle",
			{ noremap = true, silent = true },
		},
		{
			"<Leader>di",
			"<Cmd>lua require('dap').step_into()<CR>",
			mode = "n",
			desc = "step_into",
			{ noremap = true, silent = true },
		},
		{
			"<Leader>do",
			"<Cmd>lua require('dap').step_out()<CR>",
			desc = "step_out",
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<Leader>dv",
			"<Cmd>lua require('dap').step_over()<CR>",
			desc = "step_over",
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<Leader>dt",
			"<Cmd>lua require('dap').terminate()<CR>",
			desc = "terminate",
			mode = "n",
			{ noremap = true, silent = true },
		},
	})
end
