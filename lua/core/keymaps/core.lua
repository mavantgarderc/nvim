local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

local set = vim.keymap.set
local opts = { noremap = true, silent = true, }

-- Paste from OS-Integrated Clipboard
-- map("n", "<leader>p", "\"_dp", opts)

-- map("n", "<leader>ex", ":Ex<CR>",  { noremap = true,  silent = true, desc = "Open netrw" })
set("n", "<leader>pv", ":Oil<CR>", { noremap = true, silent = true, desc = "Open Oil" })

-- interactive replace word under the cursor
map("n", "<leader>x", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    print("No word under cursor")
    return
  end
  vim.api.nvim_feedkeys(
    ":%s/" .. vim.fn.escape(word, "/\\") .. "//gc" .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3),
    "n", false)
end, "Replace word under cursor interactively")

map({ "n", "v", "i" }, "<Find>", "0")
map({ "n", "v", "i" }, "<Select>", "$")
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "gg", "ggzt", "Go to Top")
map("n", "<C-b>", "<C-b>zt", "Go one page up")
map("n", "<C-u>", "<C-u>zz", "Go half page up")
map("n", "<C-d>", "<C-d>zz", "Go half page down")
map("n", "<C-f>", "<C-f>zb", "Go one page down")
map("n", "G", "Gzb", "Go to bottom")

map("i", "<C-b>", "<ESC>^i", "Go bol; 'i' mode")
map("i", "<C-h>", "<Left>", "Go left; 'i' mode")
map("i", "<C-l>", "<Right>", "Go rigth; 'i' mode")
map("i", "<C-j>", "<Down>", "Go down; 'i' mode")
map("i", "<C-k>", "<Up>", "Go up; 'i' mode")

map("i", "<C-w>", "<C-w>", "Delete word before cursor")
map("i", "<C-u>", "<C-u>", "Delete line before cursor")

map("i", "<C-t>", "<C-t>", "Indent forward")
map("i", "<C-d>", "<C-d>", "Indent backward")

map("i", "<C-n>", "<C-n>", "Suggest next")
map("i", "<C-p>", "<C-p>", "Suggest prev")
map("i", "<C-x><C-l>", "<C-x><C-l>", "Open suggestion dropdown")

map("v", "J", ":m '>+1<CR>gv=gv", "Move selected line(s) down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selected line(s) up")

set("v", "<leader>/", "gc", { remap = true, desc = "Comment the selected line(s)" })

map("n", "J", "mzJ`z", "Stand still cursor, on merging lines")

-- searching
map("n", "/", "/", "Search forward")
map("n", "?", "?", "Search backward")
map("n", "n", "nzzzv", "Next searched item")
map("n", "N", "Nzzzv", "Prev searched item")
map("n", "<Esc>", ":nohlsearch<CR>", "Clear the searching highlights")
map("n", "<C-[>", ":nohlsearch<CR>", "Clear the searching highlights")

map("n", "<C-A-S-p>", "mzyyP`zk", "Duplicate the current line")

-- Multi-Cursor
map("n", "<A-S-j>", "<Plug>(VM-Add-Cursor-Down)", "Add cursor down")
map("n", "<A-S-k>", "<Plug>(VM-Add-Cursor-Up)", "Add cursor up")

map("n", "<leader>g(", "ciw()<C-[>P", "Surround word with (); Normal")
map("n", "<leader>g[", "ciw[]<C-[>P", "Surround word with []; Normal")
map("n", "<leader>g{", "ciw{<C-[>P", "Surround word with {; Normal")
map("n", "<leader>g\"", "ciw\"\"<C-[>P", "Surround word with \"\"; Normal")
map("n", "<leader>g'", "ciw''<C-[>P", "Surround word with ''; Normal")
map("n", "<leader>g*", "ciw**<C-[>P", "Surround word with **; Normal")
map("n", "<leader>g<", "ciw<><C-[>P", "Surround word with <>; Normal")

map("v", "<leader>g(", "c()<C-[>P", "Surround word with (); Visual")
map("v", "<leader>g[", "c[]<C-[>P", "Surround word with []; Visual")
map("v", "<leader>g{", "c{<C-[>P", "Surround word with {; Visual")
map("v", "<leader>g\"", "c\"\"<C-[>P", "Surround word with \"\"; Visual")
map("v", "<leader>g'", "c''<C-[>P", "Surround word with ''; Visual")
map("v", "<leader>g*", "c**<C-[>P", "Surround word with **; Visual")
map("n", "<leader>g<", "c<><C-[>P", "Surround word with <>; Normal")
