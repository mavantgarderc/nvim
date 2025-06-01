--[[
/=================================\=============================================================================
|===  LOCAL VARIABLE MAPPINGS  ===|
\=================================/ ]]
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g

--[[
/===========================\===================================================================================
|===  KEYBOARD MAPPINGS  ===|
\===========================/ ]]
--[[
And for them whom following Grimnir's path, The Allfather
obliged be armored by 100% layout seiðr... ]]

map({ "n", "v", "i" }, "<Find>", "0", opts)
map({ "n", "v", "i" }, "<Select>", "$", opts)

map({ "n", "v", "i" }, "<F01>", ":help", opts) -- help
--map({ "n", "v", "i" }, "<F02>", "0", opts) -- rename
--map({ "n", "v", "i" }, "<F03>", "0", opts) -- indent
map({ "n", "v", "i" }, "<F04>", "0", opts) -- code action
map({ "n", "v", "i" }, "<F05>", "0", opts)
map({ "n", "v", "i" }, "<F06>", "0", opts)
map({ "n", "v", "i" }, "<F07>", "0", opts)
map({ "n", "v", "i" }, "<F08>", "0", opts)
map({ "n", "v", "i" }, "<F09>", "0", opts)
map({ "n", "v", "i" }, "<F10>", "0", opts)
map({ "n", "v", "i" }, "<F11>", "0", opts)
map({ "n", "v", "i" }, "<F12>", "0", opts)

map({ "n", "v", "i" }, "<F13>", "0", opts)
map({ "n", "v", "i" }, "<F14>", "0", opts)
map({ "n", "v", "i" }, "<F15>", "0", opts)
map({ "n", "v", "i" }, "<F16>", "0", opts)
map({ "n", "v", "i" }, "<F17>", "0", opts)
map({ "n", "v", "i" }, "<F18>", "0", opts)
map({ "n", "v", "i" }, "<F19>", "0", opts)
map({ "n", "v", "i" }, "<F20>", "0", opts)
map({ "n", "v", "i" }, "<F21>", "0", opts)
map({ "n", "v", "i" }, "<F22>", "0", opts)
map({ "n", "v", "i" }, "<F23>", "0", opts)
map({ "n", "v", "i" }, "<F24>", "0", opts)

--[[
/========================\======================================================================================
|===  PANES | BUFFERS ===|
\========================/ ]]
-- Panes
map("n", "<C-h>", ":TmuxNavigateLeft<CR>", opts)
map("n", "<C-j>", ":TmuxNavigateDown<CR>", opts)
map("n", "<C-k>", ":TmuxNavigateUp<CR>", opts)
map("n", "<C-l>", ":TmuxNavigateRight<CR>", opts)

-- Buffers
map("n", "<Leader>c", "<cmd>bd<CR>", opts) -- close current

--[[
/======================\========================================================================================
|===  FILE ACTIONS  ===|
\======================/ ]]
-- normalize pasting
map("x", "<leader>p", '"_dp')
-- replace the cursor under word, in entire buffer
map("n", "<leader>s", ":%s/\\<<C-r><C-w>>//>/<C-r><C-w>/gI<Left><Left>")

-- add execution permission
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- source current file
map("n", "<leader>o", "<cmd>source %<CR>")

--[[
/===================\===========================================================================================
|===  MOVEMENTS  ===|
\===================/ ]]
-- stand-still cursor while merging lines
map("n", "J", "mzJ`z")

-- move selected lines vertically
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Better vertical movement with wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- half page jumpings
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- duplicate lines
map("n", "<A-j>", "mzyyp`zj", { desc = "Duplicate line down" })
map("n", "<A-k>", "mzyyP`zk", { desc = "Duplicate line up" })

--[[
/======================\========================================================================================
|===  Multi-Cursor  ===|
\======================/ ]]
map({ "n", "i" }, "<A-S-j>", "<Plug>(VM-Add-Cursor-Down)", opts)
map({ "n", "i" }, "<A-S-k>", "<Plug>(VM-Add-Cursor-Up)", opts)

--[[
/===================\===========================================================================================
|===  SEARCHING  ===|
\===================/ ]]
-- cycle through searched
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
