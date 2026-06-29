local keymaps = {}

-- Basic navigation & editing
keymaps["n|<C-h>"] = { cmd = "<C-w>h", options = { noremap = true, silent = true } }
keymaps["n|<C-j>"] = { cmd = "<C-w>j", options = { noremap = true, silent = true } }
keymaps["n|<C-k>"] = { cmd = "<C-w>k", options = { noremap = true, silent = true } }
keymaps["n|<C-l>"] = { cmd = "<C-w>l", options = { noremap = true, silent = true } }

-- Resize with arrows
keymaps["n|<C-Up>"] = { cmd = ":resize -2<CR>", options = { noremap = true, silent = true } }
keymaps["n|<C-Down>"] = { cmd = ":resize +2<CR>", options = { noremap = true, silent = true } }
keymaps["n|<C-Left>"] = { cmd = ":vertical resize -2<CR>", options = { noremap = true, silent = true } }
keymaps["n|<C-Right>"] = { cmd = ":vertical resize +2<CR>", options = { noremap = true, silent = true } }

-- Navigate buffers
keymaps["n|<S-l>"] = { cmd = ":bnext<CR>", options = { noremap = true, silent = true } }
keymaps["n|<S-h>"] = { cmd = ":bprevious<CR>", options = { noremap = true, silent = true } }

-- Move text up and down
keymaps["n|<A-j>"] = { cmd = "<Esc>:m .+1<CR>==gi", options = { noremap = true, silent = true } }
keymaps["n|<A-k>"] = { cmd = "<Esc>:m .-2<CR>==gi", options = { noremap = true, silent = true } }

-- Press jk fast to exit insert mode
keymaps["i|jk"] = { cmd = "<ESC>", options = { noremap = true, silent = true } }

-- Visual: stay in indent mode
keymaps["v|<"] = { cmd = "<gv", options = { noremap = true, silent = true } }
keymaps["v|>"] = { cmd = ">gv", options = { noremap = true, silent = true } }

-- Visual: move text
keymaps["v|<A-j>"] = { cmd = ":m .+1<CR>==", options = { noremap = true, silent = true } }
keymaps["v|<A-k>"] = { cmd = ":m .-2<CR>==", options = { noremap = true, silent = true } }
keymaps["v|p"] = { cmd = '"_dP', options = { noremap = true, silent = true } }

-- Visual Block: move text
keymaps["x|J"] = { cmd = ":move '>+1<CR>gv-gv", options = { noremap = true, silent = true } }
keymaps["x|K"] = { cmd = ":move '<-2<CR>gv-gv", options = { noremap = true, silent = true } }
keymaps["x|<A-j>"] = { cmd = ":move '>+1<CR>gv-gv", options = { noremap = true, silent = true } }
keymaps["x|<A-k>"] = { cmd = ":move '<-2<CR>gv-gv", options = { noremap = true, silent = true } }

-- LSP / Lspsaga single-letter keymaps
keymaps["n|gh"] = { cmd = ":Lspsaga lsp_finder<CR>", options = { noremap = true, silent = true, desc = "LSP finder" } }
keymaps["n|K"] = { cmd = ":Lspsaga hover_doc<CR>", options = { noremap = true, silent = true, desc = "Hover doc" } }
keymaps["n|gp"] = { cmd = ":Lspsaga peek_definition<CR>", options = { noremap = true, silent = true, desc = "Peek definition" } }
keymaps["n|gd"] = { cmd = ":Lspsaga goto_definition<CR>", options = { noremap = true, silent = true, desc = "Goto definition" } }
keymaps["n|gf"] = { cmd = ":Format<CR>", options = { noremap = true, silent = true, desc = "Format buffer" } }

-- File / find
keymaps["n|<leader>f"] = { cmd = ":lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>", options = { noremap = true, silent = true, desc = "Find file" } }
keymaps["n|<C-t>"] = { cmd = ":Telescope live_grep<CR>", options = { noremap = true, silent = true, desc = "Live grep" } }
keymaps["n|<leader>F"] = { cmd = ":Telescope live_grep theme=ivy<CR>", options = { noremap = true, silent = true, desc = "Find text" } }
keymaps["n|<leader>b"] = { cmd = ":lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>", options = { noremap = true, silent = true, desc = "Find buffers" } }
keymaps["n|<leader>P"] = { cmd = ":Telescope projects<CR>", options = { noremap = true, silent = true, desc = "Projects" } }

-- Explorer
keymaps["n|<leader>e"] = { cmd = ":NvimTreeToggle<CR>", options = { noremap = true, silent = true, desc = "Explorer" } }

-- Comment
keymaps["n|<leader>/"] = { cmd = "<Plug>(comment_toggle_linewise_current)", options = { noremap = true, silent = true, desc = "Comment" } }
keymaps["v|<leader>/"] = { cmd = "<Plug>(comment_toggle_linewise_visual)", options = { noremap = true, silent = true, desc = "Comment" } }

-- Buffer / window
keymaps["n|<leader>a"] = { cmd = ":Alpha<CR>", options = { noremap = true, silent = true, desc = "Alpha" } }
keymaps["n|<leader>c"] = { cmd = ":BufDel<CR>", options = { noremap = true, silent = true, desc = "Close buffer" } }
keymaps["n|<leader>w"] = { cmd = ":w!<CR>", options = { noremap = true, silent = true, desc = "Save" } }
keymaps["n|<leader>q"] = { cmd = ":q!<CR>", options = { noremap = true, silent = true, desc = "Quit" } }
keymaps["n|<leader>h"] = { cmd = ":nohlsearch<CR>", options = { noremap = true, silent = true, desc = "No highlight" } }

-- Package (Lazy)
keymaps["n|<leader>pc"] = { cmd = ":Lazy clean<CR>", options = { noremap = true, silent = true, desc = "Lazy clean" } }
keymaps["n|<leader>ps"] = { cmd = ":Lazy sync<CR>", options = { noremap = true, silent = true, desc = "Lazy sync" } }
keymaps["n|<leader>pS"] = { cmd = ":Lazy show<CR>", options = { noremap = true, silent = true, desc = "Lazy show" } }

-- LSP
keymaps["n|<leader>la"] = { cmd = ":Lspsaga code_action<CR>", options = { noremap = true, silent = true, desc = "Code action" } }
keymaps["n|<leader>ld"] = { cmd = ":Lspsaga show_buf_diagnostics<CR>", options = { noremap = true, silent = true, desc = "Document diagnostics" } }
keymaps["n|<leader>lw"] = { cmd = ":Lspsaga show_workspace_diagnostics<CR>", options = { noremap = true, silent = true, desc = "Workspace diagnostics" } }
keymaps["n|<leader>li"] = { cmd = ":LspInfo<CR>", options = { noremap = true, silent = true, desc = "LSP info" } }
keymaps["n|<leader>lf"] = { cmd = ":Lspsaga finder def+ref<CR>", options = { noremap = true, silent = true, desc = "LSP finder" } }
keymaps["n|<leader>lj"] = { cmd = ":Lspsaga diagnostic_jump_next<CR>", options = { noremap = true, silent = true, desc = "Next diagnostic" } }
keymaps["n|<leader>lk"] = { cmd = ":Lspsaga diagnostic_jump_prev<CR>", options = { noremap = true, silent = true, desc = "Prev diagnostic" } }
keymaps["n|<leader>lr"] = { cmd = ":Lspsaga rename<CR>", options = { noremap = true, silent = true, desc = "Rename" } }
keymaps["n|<leader>ls"] = { cmd = ":Telescope lsp_document_symbols<CR>", options = { noremap = true, silent = true, desc = "Document symbols" } }
keymaps["n|<leader>lS"] = { cmd = ":Telescope lsp_dynamic_workspace_symbols<CR>", options = { noremap = true, silent = true, desc = "Workspace symbols" } }

-- DAP
keymaps["n|<leader>db"] = { cmd = ":lua require('dap').toggle_breakpoint()<CR>", options = { noremap = true, silent = true, desc = "Toggle breakpoint" } }
keymaps["n|<leader>dc"] = { cmd = ":lua require('dap').continue()<CR>", options = { noremap = true, silent = true, desc = "Continue" } }
keymaps["n|<leader>dr"] = { cmd = ":lua require('dap').repl.toggle({height = math.floor(vim.o.lines / 3)})<CR>", options = { noremap = true, silent = true, desc = "REPL toggle" } }
keymaps["n|<leader>di"] = { cmd = ":lua require('dap').step_into()<CR>", options = { noremap = true, silent = true, desc = "Step into" } }
keymaps["n|<leader>do"] = { cmd = ":lua require('dap').step_out()<CR>", options = { noremap = true, silent = true, desc = "Step out" } }
keymaps["n|<leader>dv"] = { cmd = ":lua require('dap').step_over()<CR>", options = { noremap = true, silent = true, desc = "Step over" } }
keymaps["n|<leader>dt"] = { cmd = ":lua require('dap').terminate()<CR>", options = { noremap = true, silent = true, desc = "Terminate" } }

-- Terminal
keymaps["n|<leader>o"] = { cmd = ":Lspsaga outline<CR>", options = { noremap = true, silent = true, desc = "Outline" } }
keymaps["n|<C-\\>"] = { cmd = ":ToggleTerm direction=horizontal<CR>", options = { noremap = true, silent = true, desc = "Toggle terminal" } }
keymaps["t|<C-\\>"] = { cmd = ":ToggleTerm<CR>", options = { noremap = true, silent = true, desc = "Toggle terminal" } }

return keymaps
