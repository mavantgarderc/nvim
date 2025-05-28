local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local keymap = vim.keymap


g.mapleader = " "
g.maplocalleader = "\\"
opt.smartindent = true
keymap.set('n', "<leader>pv", cmd.Ex)
cmd("let g:loaded_ruby_provider = 0")
cmd("let g:loaded_perl_provider = 0")


cmd("set expandtab")
cmd("set tabstop=4")
cmd("set softtabstop=4")
cmd("set shiftwidth=4")
opt.number = true
opt.relativenumber = true
opt.expandtab = true    -- Convert tabs to spaces

vim.schedule(function()    -- OS-Nvim clipboard sync
    vim.o.clipboard = "unnamedplus"
end)


vim.o.showmode = false -- don't show the mode (shown in lualine)

vim.o.cursorline = true -- show which line cursor is on

vim.o.list = true -- display whitespaces
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }


opt.wrap = false
opt.swapfile = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = true    -- Show matches while typing
opt.incsearch = true   -- Highlight all matches

opt.termguicolors = true  -- enable 24-bit RGB colors

opt.scrolloff = 7
opt.signcolumn = "yes"    -- Always show sign column (LSP, Git, etc.)
opt.isfname:append("@-@")

opt.updatetime = 50
-- fat cursors... thick one....
-- vim.opt.guicursor = ""

opt.splitright = true        -- Vertical splits open to the right
opt.splitbelow = true        -- Horizontal splits open below

-- =============================================================================

-- LazyGit
-- transparency of floating window
vim.g.lazygit_floating_window_winblend = 0
-- scaling factor for floating window
vim.g.lazygit_floating_window_scaling_factor = 0.9
-- customize lazygit popup window border characters
vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'}
-- use plenary.nvim to manage floating window if available
vim.g.lazygit_floating_window_use_plenary = 0
-- fallback to 0 if neovim-remote is not installed
vim.g.lazygit_use_neovim_remote = 1
-- config file path is evaluated if this value is 1
vim.g.lazygit_use_custom_config_file_path = 0
-- custom config file path (you can use {} instead of '')
vim.g.lazygit_config_file_path = ''
-- optional function callback when exiting lazygit (useful for example to refresh some UI elements after lazy git has made some changes)
vim.g.lazygit_on_exit_callback = nil
