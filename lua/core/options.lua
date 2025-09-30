local opt = vim.opt
local g = vim.g
local o = vim.o
local schedule = vim.schedule
local map = vim.keymap
local opt_local = vim.opt_local

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
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

if vim.fn.has("win32") == 1 then
    mason_bin = mason_bin:gsub("/", "\\")
    vim.env.PATH = mason_bin .. ";" .. vim.env.PATH
else
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

opt_local.wrap = false        -- disable line wrapping by default
opt_local.linebreak = false   -- disable word-boundary wrapping by default
opt_local.textwidth = 135     -- recommended column width
opt_local.colorcolumn = ""    -- disable visual marker by default
local grp = vim.api.nvim_create_augroup("GlobalWrap", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
    group = grp,
    callback = function()
        if vim.w.__wrap_user_enabled then
            vim.wo.wrap = true
            vim.wo.linebreak = true
            vim.wo.colorcolumn = "135"
        else
            vim.wo.wrap = false
            vim.wo.linebreak = false
            vim.wo.colorcolumn = ""
        end
    end,
})
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
  end,
})
