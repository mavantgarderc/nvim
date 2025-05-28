local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better vertical movement with wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- splits navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
-- Tmux Navigation
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprevCR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Resize splits with arrows
map("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Close current buffer
map("n", "<Leader>c", "<cmd>bd<CR>", opts)

-- Explorer (Neotree or netrw fallback)
map("n", "<Leader>e", "<cmd>Neotree toggle<CR>", opts)

-- move selected lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- merge lines without moving the cursor
map("n", "J", "mzJ`z")

-- half page jumpings
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep searched terms stay in the middle
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- normalize pasting
map("x", "<leader>p", "\"_dp")

-- tmux, previous session...
-- change your project
map("n", "<C-f>", "<cmd>silent !tmux new tmux sessionizer<CR>")

-- the cursor on a word, change the word in entire file
map("n", "<leader>s", ":%s/\\<<C-r><C-w>>//>/<C-r><C-w>/gI<Left><Left>")
-- make a file, make it executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
