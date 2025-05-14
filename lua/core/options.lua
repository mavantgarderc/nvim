vim.cmd("let g:loaded_ruby_provider = 0")
vim.cmd("let g:loaded_perl_provider = 0")

-- ===
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

--vim.opt.colorcolumn = "80"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.smartindent = true
vim.keymap.set('n', "<leader>pv", vim.cmd.Ex)

-- fat cursors... thick one....
-- vim.opt.guicursor = ""




-- local opt = vim.opt
-- local g = vim.g

-- -- GENERAL --------------------------------------------------------------------
-- opt.mouse = "a"              -- Enable mouse support in all modes
-- opt.clipboard = "unnamedplus" -- Sync with system clipboard
-- opt.swapfile = false         -- Disable swapfile
-- opt.backup = false           -- Disable backup
-- opt.undofile = true          -- Persistent undo
-- opt.confirm = true           -- Confirm on unsaved changes
-- opt.hidden = true            -- Allow switching buffers without saving

-- -- UI -------------------------------------------------------------------------
-- opt.number = true            -- Show absolute line numbers
-- opt.relativenumber = true    -- Show relative line numbers
-- opt.cursorline = true        -- Highlight current line
-- opt.termguicolors = true     -- Enable 24-bit RGB colors
-- opt.signcolumn = "yes"       -- Always show sign column (LSP, Git, etc.)
-- opt.scrolloff = 10           -- Vertical padding from screen edge
-- opt.sidescrolloff = 8        -- Horizontal padding from screen edge
-- opt.splitright = true        -- Vertical splits open to the right
-- opt.splitbelow = true        -- Horizontal splits open below

-- -- INDENTATION & TABS ---------------------------------------------------------
-- opt.expandtab = true         -- Convert tabs to spaces
-- opt.shiftwidth = 4           -- Indentation size
-- opt.tabstop = 4              -- Tab key inserts 4 spaces
-- opt.smartindent = true       -- Autoindent new lines
-- opt.breakindent = true       -- Indent wrapped lines visually

-- -- SEARCH ---------------------------------------------------------------------
-- opt.ignorecase = true        -- Case-insensitive by default
-- opt.smartcase = true         -- Case-sensitive if uppercase used
-- opt.incsearch = true         -- Show matches while typing
-- opt.hlsearch = true          -- Highlight all matches

-- -- PERFORMANCE ----------------------------------------------------------------
-- opt.lazyredraw = true        -- Don’t redraw while running macros
-- opt.timeoutlen = 400         -- Keybinding timeout (ms)
-- opt.updatetime = 200         -- CursorHold delay (ms)

-- -- FILES & PATHS --------------------------------------------------------------
-- opt.backupskip = { "/tmp/*", "/private/tmp/*" }
-- opt.inccommand = "split"     -- Live preview of :substitute
-- opt.fileencoding = "utf-8"   -- Use UTF-8 encoding
-- opt.autoread = true          -- Reload files changed outside of Neovim

-- -- COMPLETION -----------------------------------------------------------------
-- opt.completeopt = { "menu", "menuone", "noselect" } -- Completion behavior
-- opt.wildmenu = true          -- Enhanced command line completion

-- -- DIAGNOSTICS / MISC ---------------------------------------------------------
-- opt.foldmethod = "expr"      -- Use Treesitter/indent expressions
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldlevel = 99           -- Open all folds by default

-- -- GLOBAL VARIABLES -----------------------------------------------------------
-- g.mapleader = " "            -- Leader key set to space
-- g.loaded_perl_provider = 0   -- Disable unused language providers
-- g.loaded_ruby_provider = 0
-- g.loaded_node_provider = 0
-- g.loaded_python3_provider = 0