local map = vim.keymap.set
local opts = { noremap = true, silent = true, }

-- Oil
map("n", "<leader>pv", ":Oil<CR>", opts)

-- Paste from OS-Integrated Clipboard
map("n", "<leader>p", "\"_dP", opts)

map("n", "s", "xi")

-- Movement
map({ "n", "v", "i" }, "<Find>", "0")
map({ "n", "v", "i" }, "<Select>", "$")
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "gg", "ggzt")
map("n", "<C-b>", "<C-b>zt") -- one   pg up
map("n", "<C-u>", "<C-u>zz") -- half  pg up
map("n", "<C-d>", "<C-d>zz") -- half  pg dn
map("n", "<C-f>", "<C-f>zb") -- one   pg dn
map("n", "G", "Gzb")

map("i", "<C-b>", "<ESC>^i")
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

map("i", "<C-w>", "<C-w>") -- delete word before cursor
map("i", "<C-u>", "<C-u>") -- delete line before cursor

map("i", "<C-t>", "<C-t>") -- indent forward
map("i", "<C-d>", "<C-d>") -- indent backward

map("i", "<C-n>", "<C-n>") -- suggest next
map("i", "<C-p>", "<C-p>") -- suggest prev
map("i", "<C-x><C-l>", "<C-x><C-l>") -- open suggestion dropdown

-- move selected lines vertically
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Comments
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- stand-still cursor while merging lines
map("n", "J", "mzJ`z")

-- searching
map("n", "/", "/", { desc = "Search forward" })
map("n", "?", "?", { desc = "Search backward" })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- duplicate lines
map("n", "<C-A-S-k>", "mzyyP`zk")

-- Multi-Cursor
map("n", "<A-S-j>", "<Plug>(VM-Add-Cursor-Down)", opts)
map("n", "<A-S-k>", "<Plug>(VM-Add-Cursor-Up)",   opts)
