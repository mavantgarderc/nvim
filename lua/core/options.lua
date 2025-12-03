local opt = vim.opt
local g = vim.g
local o = vim.o
local schedule = vim.schedule
local map = vim.keymap
local opt_local = vim.opt_local

map.set("n", "<leader>J", "<Nop>")
map.set("n", "gc", "<Nop>")

-- Disable netrw (if you use another file explorer like oil.nvim, nvim-tree, etc.)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Leader keys
g.mapleader = " " -- global <Leader> is Space
g.maplocalleader = "\\" -- <LocalLeader> is backslash

-- Smarter auto-indentation on new lines
opt.smartindent = true

-- Disable language providers you don't use (speed + no provider warnings)
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Don't force markdown recommended defaults (let your config decide)
g.markdown_recommended_style = 0

-- mason.nvim $PATH setup
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.has("win32") == 1 then
	mason_bin = mason_bin:gsub("/", "\\")
	vim.env.PATH = mason_bin .. ";" .. vim.env.PATH
else
	vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- Global wrapping defaults + per-window toggle
opt_local.wrap = false -- do not soft-wrap long lines by default
opt_local.linebreak = false -- don't wrap at word boundaries by default
opt_local.textwidth = 120 -- recommended text width for formatting
opt_local.colorcolumn = "" -- no static colorcolumn marker by default

-- Autocmd group that enforces wrap/linebreak/colorcolumn based on a window flag
local grp = vim.api.nvim_create_augroup("GlobalWrap", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
	group = grp,
	callback = function()
		if vim.w.__wrap_user_enabled then
			vim.wo.wrap = true
			vim.wo.linebreak = true
			vim.wo.colorcolumn = "120"
		else
			vim.wo.wrap = false
			vim.wo.linebreak = false
			vim.wo.colorcolumn = ""
		end
	end,
})

-- Toggle wrapping for the current window (sticky per-window toggle)
local function toggle_wrap()
	if vim.w.__wrap_user_enabled then
		vim.w.__wrap_user_enabled = nil
		vim.wo.wrap = false
		vim.wo.linebreak = false
		vim.wo.colorcolumn = ""
		print("Wrap OFF")
	else
		vim.w.__wrap_user_enabled = true
		vim.wo.wrap = true
		vim.wo.linebreak = true
		vim.wo.colorcolumn = "135"
		print("Wrap ON (sticky for this window)")
	end
end
map.set("n", "<leader>ww", toggle_wrap, { desc = "Toggle line wrap, linebreak, and colorcolumn" })

opt.number = true -- show absolute line number on the current line
opt.relativenumber = true -- show relative line numbers on others
opt.numberwidth = 2 -- minimum width of line number column

-- Indentation behavior (tabs, width, etc.)
opt.expandtab = false -- use actual <Tab> characters, do NOT convert to spaces
opt.tabstop = 2 -- how many columns a <Tab> counts for visually
opt.shiftwidth = 2 -- indent width for >>, <<, == operations
opt.softtabstop = 2 -- how many columns <Tab>/<BS> move in insert mode

-- Clipboard: delay until after startup to avoid slow startup on some systems
schedule(function() -- OS ↔ Neovim clipboard sync
	o.clipboard = "unnamedplus" -- use system clipboard for all yank/put
end)

o.showmode = true -- don't show mode like -- INSERT -- (statusline should handle this)

o.cursorline = true -- highlight the line with the cursor
-- o.guicursor = ""  -- Uncomment to force block cursor everywhere
o.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor" -- fine-grained cursor shapes

o.list = true -- show whitespace characters according to 'listchars'

-- Symbols used to represent whitespace when 'list' is on
opt.listchars = {
	tab = "» ", -- show tabs as » plus a space
	trail = "·", -- show trailing spaces as ·
	nbsp = "␣", -- show non-breaking spaces as ␣
}

opt.wrap = false -- don't soft-wrap by default in general
opt.swapfile = false -- disable swap files (less clutter, more risk if crash)
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- persistent undo directory
opt.undofile = true -- enable persistent undo across sessions

opt.hlsearch = true -- highlight all matches of the last search
opt.incsearch = true -- show incremental search results as you type

opt.termguicolors = true -- enable 24-bit RGB colors
vim.o.termguicolors = true -- (duplicate, but harmless; ensures it's on)

opt.scrolloff = 9 -- keep at least 1 line above/below cursor when scrolling
opt.signcolumn = "yes" -- always show sign column (avoids text shifting)
opt.isfname:append("@-@") -- treat @-@ as part of file names

opt.updatetime = 20 -- faster CursorHold & swap writes (default is 4000ms)

opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below

-- Enable spellchecking in markdown buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_us" }
	end,
})
