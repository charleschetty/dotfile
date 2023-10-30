local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)



keymap("n", "<leader>f",
  "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
  opts)
keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)
--[[ keymap("n", "<leader>ca", "<cmd>lua  require('telescope.builtin').lsp_code_actions(:with)<CR>", opts) ]]


keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)


keymap('n', '<leader>rf', ':w<Esc>:RunFile<CR>', opts)
keymap('n', '<leader>rc', ':RunClose<CR>', opts)

keymap('n', '<leader>t', ':TroubleToggle<cr>', opts)
vim.api.nvim_create_user_command('RustEnableInlayHints', "lua require('rust-tools').inlay_hints.set()", {})
vim.api.nvim_create_user_command('RustDisableInlayHints', "lua require('rust-tools').inlay_hints.unset()", {})
vim.api.nvim_create_user_command('Spectre', "lua require('spectre').open()", {})
vim.api.nvim_create_user_command('Spectrefile', "lua require('spectre').open_file_search()", {})


keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
keymap("n", "<leader>lf", "<cmd>Lspsaga finder def+ref<cr>", opts)
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
keymap("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", opts)
keymap("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", opts)
keymap("n", "<leader>lj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
keymap("n", "<leader>lk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)
keymap("n", "<C-\\>", "<cmd>ToggleTerm<CR>", opts)

vim.api.nvim_set_keymap('i', '<A-l>', "<Plug>(TaboutMulti)", { silent = true })
vim.api.nvim_set_keymap('i', '<A-h>', "<Plug>(TaboutBackMulti)", { silent = true })

