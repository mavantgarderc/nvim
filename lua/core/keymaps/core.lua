local map = vim.keymap.set
local opts = { noremap = true, silent = true, }
local cmd = vim.cmd

-- netrw
map('n', "<leader>pv", cmd.Ex)

-- Paste
map("n", "<leader>p", "\"_dP", opts)

-- Insert Mode Movement
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Comments
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- stand-still cursor while merging lines
map("n", "J", "mzJ`z")

-- move selected lines vertically
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Better vertical movement with wrapped lines
map({ "n", "v", "i" }, "<Find>", "0", opts)
map({ "n", "v", "i" }, "<Select>", "$", opts)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- half page jumpings
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- duplicate lines
map("n", "<C-A-j>", "mzyyp`zj", { desc = "Duplicate line down" })
map("n", "<C-A-k>", "mzyyP`zk", { desc = "Duplicate line up" })

-- searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<Esc>", ":nohlsearch<CR>", opts)
--map("n", "<Esc>", ":noh<CR>", opts)

-- Multi-Cursor
map({ "n", "i" }, "<A-S-j>", "<Plug>(VM-Add-Cursor-Down)", opts)
map({ "n", "i" }, "<A-S-k>", "<Plug>(VM-Add-Cursor-Up)", opts)
