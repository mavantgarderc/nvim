-- Core Neovim settings

local opt = vim.opt

opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.swapfile = false -- Disable swap files
opt.backup = false -- Disable backup
opt.undofile = true -- Persistent undo
opt.ignorecase = true -- Case-insensitive searching...
opt.smartcase = true -- ...unless capital letters are used
opt.termguicolors = true -- True color support
opt.signcolumn = "yes" -- Always show sign column
opt.updatetime = 250 -- Faster completion
opt.timeoutlen = 300 -- Faster key timeout
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Horizontal split below
opt.scrolloff = 8 -- Keep lines above/below cursor
opt.sidescrolloff = 8
opt.wrap = false -- Disable line wrap
