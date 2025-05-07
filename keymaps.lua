-- <Space> as leader key
vim.g.mapleader = ' '

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Save file
map('n', '<C-s>', ':w<CR>', opts)

-- Open file explorer
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Fuzzy finder
map('n', '<leader>f', ':Telescope find_files<CR>', opts)
map('n', '<leader>g', ':Telescope live_grep<CR>', opts)
