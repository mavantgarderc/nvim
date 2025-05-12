-- ============================================================================
-- Keymaps and Modal Bindings — core/keymaps.lua
-- ============================================================================
-- Custom keybindings for normal, insert, visual, and terminal modes
-- using <Leader> and consistent ergonomics.
-- ============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LEADER KEYS ----------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- GENERAL NAVIGATION ---------------------------------------------------------

-- Better vertical movement with wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Faster window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize splits with arrows
map("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- BUFFERS + FILES ------------------------------------------------------------

-- Save and quit
map("n", "<Leader>w", "<cmd>w<CR>", opts)
map("n", "<Leader>q", "<cmd>q<CR>", opts)

-- Close current buffer
map("n", "<Leader>c", "<cmd>bd<CR>", opts)

-- Explorer (Neotree or netrw fallback)
map("n", "<Leader>e", "<cmd>Neotree toggle<CR>", opts)

-- INSERT MODE ----------------------------------------------------------------

-- Fast escape with jk
map("i", "jk", "<Esc>", opts)

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- TERMINAL -------------------------------------------------------------------

-- Terminal mode to normal mode
map("t", "<Esc>", [[<C-\><C-n>]], opts)

-- PLUGIN SHORTCUTS (to be defined later) ------------------------------------

-- Telescope
map("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- GitSigns
map("n", "]g", "<cmd>Gitsigns next_hunk<CR>", opts)
map("n", "[g", "<cmd>Gitsigns prev_hunk<CR>", opts)

-- DAP (debugging, will hook into dap.lua later)
map("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", opts)
map("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<Leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)

-- ============================================================================
-- 🧠 Keymap layer initialized
-- ============================================================================