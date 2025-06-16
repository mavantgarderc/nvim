local opt = vim.opt
local g = vim.g
local o = vim.o
local cmd = vim.cmd
local keymap = vim.keymap
local schedule = vim.schedule
local env = vim.env

g.mapleader = " "
g.maplocalleader = "\\"
opt.smartindent = true
keymap.set('n', "<leader>pv", cmd.Ex)

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
--local is_windows = fn.has "win32" ~= 0
--local sep = is_windows and "\\" or "/"
--local delim = is_windows and ";" or ":"
--env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

opt.number = true
--opt.relativenumber = true
opt.numberwidth = 2

opt.expandtab = true    -- Convert tabs to spaces
opt.shiftwidth = 4
opt.softtabstop =  4
opt.tabstop = 4

schedule(function()    -- OS-Nvim clipboard sync
    o.clipboard = "unnamedplus"
end)

o.showmode = false -- don't show the mode (shown in lualine)

o.cursorline = false -- show which line cursor is on

o.list = true -- display whitespaces

opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

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
--opt.guicursor = ""

opt.splitright = true        -- Vertical splits open to the right
opt.splitbelow = true        -- Horizontal splits open below

-- =============================================================================

-- LazyGit
-- transparency of floating window
g.lazygit_floating_window_winblend = 0
-- scaling factor for floating window
g.lazygit_floating_window_scaling_factor = 0.9
-- customize lazygit popup window border characters
g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'}
-- use plenary.nvim to manage floating window if available
g.lazygit_floating_window_use_plenary = 0
-- fallback to 0 if neovim-remote is not installed
g.lazygit_use_neovim_remote = 1
-- config file path is evaluated if this value is 1
g.lazygit_use_custom_config_file_path = 0
-- custom config file path (you can use {} instead of '')
g.lazygit_config_file_path = ''
-- optional function callback when exiting lazygit (useful for example to refresh some UI elements after lazy git has made some changes)
g.lazygit_on_exit_callback = nil
