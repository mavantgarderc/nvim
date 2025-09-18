local opt = vim.opt
local g = vim.g
local o = vim.o
local fn = vim.fn
local env = vim.env
local schedule = vim.schedule
local map = vim.keymap
local opt_local = vim.opt_local
local wo = vim.wo
local api = vim.api
local w = vim.w

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
g.markdown_recommended_style = 0

-- add binaries installed by mason.nvim to path
local mason_bin = fn.stdpath("data") .. "/mason/bin"

if fn.has("win32") == 1 then
    mason_bin = mason_bin:gsub("/", "\\")
    env.PATH = mason_bin .. ";" .. env.PATH
else
    env.PATH = mason_bin .. ":" .. env.PATH
end

opt_local.wrap = false         -- wrap lines visually
opt_local.linebreak = false    -- wrap at word boundaries
opt_local.textwidth = 130     -- recommended column width
opt_local.colorcolumn = "130" -- visual guide
local grp = api.nvim_create_augroup("GlobalWrap", { clear = true })
api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
  group = grp,
  callback = function()
    if w.__wrap_user_disabled then return end
    wo.wrap = true
    wo.linebreak = true
    wo.colorcolumn = "130"
  end,
})
local function toggle_wrap()
  if w.__wrap_user_disabled then
    w.__wrap_user_disabled = nil
    wo.wrap = true
    wo.linebreak = true
    wo.colorcolumn = "130"
    print("Wrap ON")
  else
    w.__wrap_user_disabled = true
    wo.wrap = false
    wo.linebreak = false
    wo.colorcolumn = ""
    print("Wrap OFF (sticky for this window)")
  end
end
map.set("n", "<leader>ww", toggle_wrap, { desc = "Toggle line wrap" })

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

o.showmode = false   -- don not show the mode (shown in commandline)

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
