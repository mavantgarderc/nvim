-- <Space> as leader key
vim.g.mapleader = ' '

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local map = vim.keymap.set
-- Save file 
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<C-s>", ':w<CR>', opts)
-- Quit window
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })

-- Open file explorer
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Fuzzy finder
map('n', '<leader>f', ':Telescope find_files<CR>', opts)
map('n', '<leader>g', ':Telescope live_grep<CR>', opts)
