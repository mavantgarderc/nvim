local opt = vim.opt
local g = vim.g
local o = vim.o
local fn = vim.fn
local env = vim.env
local schedule = vim.schedule
local map = vim.keymap

map.set("n", "<leader>J", "<Nop>")
map.set("n", "gc", "<Nop>")

-- Disable netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

g.mapleader = " "
g.maplocalleader = "\\"
opt.smartindent = true

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local mason_bin = fn.stdpath("data") .. "/mason/bin"

if fn.has("win32") == 1 then
    mason_bin = mason_bin:gsub("/", "\\")
    env.PATH = mason_bin .. ";" .. env.PATH
else
    env.PATH = mason_bin .. ":" .. env.PATH
end

opt.number = true
--opt.relativenumber = true
opt.numberwidth = 2

opt.expandtab = true -- Convert tabs to spaces
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

schedule(function() -- OS-Nvim clipboard sync
    o.clipboard = "unnamedplus"
end)

o.showmode = false   -- don not show the mode (shown in lualine)

o.cursorline = false -- show which line cursor is on
-- opt.guicursor = ""
opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"

o.list = true -- display whitespaces

opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.wrap = false
opt.swapfile = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 3
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

opt.splitright = true
opt.splitbelow = true
