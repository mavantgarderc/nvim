local map = vim.keymap.set
local opts = { noremap = true, silent = true, }

-- Paste from OS-Integrated Clipboard
-- map("n", "<leader>p", "\"_dp", opts)

-- Oil
map("n", "<leader>pv", ":Oil<CR>", { noremap = true, silent = true, desc = "Open Oil"})

map({ "n", "v", "i" }, "<Find>",   "0")
map({ "n", "v", "i" }, "<Select>", "$")
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "gg", "ggzt", { desc = "Go to Top" })
map("n", "<C-b>", "<C-b>zt", { desc = "Go one page up"    })
map("n", "<C-u>", "<C-u>zz", { desc = "Go half page up"   })
map("n", "<C-d>", "<C-d>zz", { desc = "Go half page down" })
map("n", "<C-f>", "<C-f>zb", { desc = "Go one page down"  })
map("n", "G", "Gzb", { desc = "Go to bottom" })

map("i", "<C-b>", "<ESC>^i", { desc = "Go bol; 'i' mode"   })
map("i", "<C-h>", "<Left>",  { desc = "Go left; 'i' mode"  })
map("i", "<C-l>", "<Right>", { desc = "Go rigth; 'i' mode" })
map("i", "<C-j>", "<Down>",  { desc = "Go down; 'i' mode"  })
map("i", "<C-k>", "<Up>",    { desc = "Go up; 'i' mode"    })

map("i", "<C-w>", "<C-w>", { desc = "Delete word before cursor"})
map("i", "<C-u>", "<C-u>", { desc = "Delete line before cursor"})

map("i", "<C-t>", "<C-t>", { desc = "Indent forward"  })
map("i", "<C-d>", "<C-d>", { desc = "Indent backward" })

map("i", "<C-n>", "<C-n>", { desc = "Suggest next" })
map("i", "<C-p>", "<C-p>", { desc = "Suggest prev" })
map("i", "<C-x><C-l>", "<C-x><C-l>", { desc = "Open suggestion dropdown"})

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line(s) down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line(s) up"   })

map("v", "<leader>/", "gc",  { remap = true, desc = "Comment the selected line(s)" })

map("n", "J", "mzJ`z", { desc = "Stand still cursor, on merging lines" })

-- searching
map("n", "/", "/", { desc = "Search forward"  })
map("n", "?", "?", { desc = "Search backward" })
map("n", "n", "nzzzv", { desc = "Next searched item" })
map("n", "N", "Nzzzv", { desc = "Prev searched item" })
map("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear the searching highlights" })
map("n", "<C-[>", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear the searching highlights" })

map("n", "<C-A-S-p>", "mzyyP`zk", { desc = "Duplicate the current line" })

-- Multi-Cursor
map("n", "<A-S-j>", "<Plug>(VM-Add-Cursor-Down)", { noremap = true, silent = true, desc = "Add cursor down" })
map("n", "<A-S-k>", "<Plug>(VM-Add-Cursor-Up)",   { noremap = true, silent = true, desc = "Add cursor up"   })

map("n", "<leader>g(",  "ciw()<C-[>P",   { desc = "Surround word with (); Normal"   })
map("n", "<leader>g[",  "ciw[]<C-[>P",   { desc = "Surround word with []; Normal"   })
map("n", "<leader>g{",  "ciw{}<C-[>P",   { desc = "Surround word with {}; Normal"   })
map("n", "<leader>g\"", "ciw\"\"<C-[>P", { desc = "Surround word with \"\"; Normal" })
map("n", "<leader>g'",  "ciw''<C-[>P",   { desc = "Surround word with ''; Normal"   })
map("n", "<leader>g*",  "ciw**<C-[>P",   { desc = "Surround word with **; Normal"   })
map("n", "<leader>g<",  "ciw<><C-[>P",   { desc = "Surround word with <>; Normal"   })

map("v", "<leader>g(",  "c()<C-[>P",     { desc = "Surround word with (); Visual"   })
map("v", "<leader>g[",  "c[]<C-[>P",     { desc = "Surround word with []; Visual"   })
map("v", "<leader>g{",  "c{}<C-[>P",     { desc = "Surround word with {}; Visual"   })
map("v", "<leader>g\"", "c\"\"<C-[>P",   { desc = "Surround word with \"\"; Visual" })
map("v", "<leader>g'",  "c''<C-[>P",     { desc = "Surround word with ''; Visual"   })
map("v", "<leader>g*",  "c**<C-[>P",     { desc = "Surround word with **; Visual"   })
map("n", "<leader>g<",  "c<><C-[>P",     { desc = "Surround word with <>; Normal"   })
