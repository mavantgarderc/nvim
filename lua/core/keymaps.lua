--[[
/=================================\=============================================================================
|===  LOCAL VARIABLE MAPPINGS  ===|
\=================================/ ]]
local opts = { noremap = true, silent = true }
local map = vim.keymap.set
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local bo = vim.bo
local trim = vim.trim
local api = vim.api
local lsp = vim.lsp
local notify = vim.notify
local diagnostics = vim.diagnostic
local o = vim.o
local log = vim.log

--[[
/===========================\===================================================================================
|===  KEYBOARD MAPPINGS  ===|
\===========================/ ]]
--[[
And for them whom following Grimnir's path, The Allfather
obliged be armored by 100% layout seiðr... ]]

map({ "n", "v", "i" }, "<Find>", "0", opts)
map({ "n", "v", "i" }, "<Select>", "$", opts)

-- === F Key ===
-- F01: Help
-- F02: LSP Rename
-- F03: LSP Format buffer/selection
-- F04: LSP Code action
-- F05: Toggle tree-sitter playground (requires nvim-treesitter/playground)
-- F06: Toggle Diagnostics Virtual Text
-- F07: Spellcheck toggle
-- F08: Telescope live grep (project search)
-- F09: Restart LSP
-- F10: Toggle Relative Line Numbers
-- F11: Treesitter highlight floater
-- F12: LSP Go to Definition
-- === F-SHIFT Key ===

map({ "n", "v", "i" }, "<F01>", ":help<CR>",
    { desc = "Help",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F02>", function()
  if lsp and lsp.buf and lsp.buf.rename then
    lsp.buf.rename()
  else
    notify("LSP rename not available")
  end
end, { desc = "LSP Rename",
        noremap = true, silent = true })

map({ "n", "v", "i" }, "<F03>", function()
  if lsp and lsp.buf and lsp.buf.format then
    lsp.buf.format()
  else
    notify("LSP format not available")
  end
end, { desc = "LSP format buffer/selection",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F04>", function()
  if lsp and lsp.buf and lsp.buf.code_action then
    lsp.buf.code_action()
  else
    notify("LSP code action not available")
  end
end, { desc = "LSP Code Action",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F5>", "<Cmd>TSPlaygroundToggle<CR>",
    { desc = "Tree-sitter Playground",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F6>", function()
  if diagnostics and diagnostics.config then
    local current = diagnostics.config().virtual_text
    diagnostics.config({ virtual_text = not current })
    notify("LSP virtual text " .. (not current and "enabled" or "disabled"))
  else
    notify("vim.diagnostic is not available in this session", log.levels.ERROR)
  end
end, { desc = "Toggle LSP Diagnostics Virtual Text",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F7>", "<Cmd>setlocal spell! spelllang=en_us<CR>",
    { desc = "Toggle Spellcheck",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F8>", "<Cmd>Telescope live_grep<CR>",
    { desc = "Project Search (Telescope)",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F9>", function()
  cmd("LspRestart")
end, { desc = "Restart LSP",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F10>", function()
  o.relativenumber = not o.relativenumber
end, { desc = "Toggle Relative Line Numbers",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F11>", "<Cmd>TSHighlightCapturesUnderCursor<CR>",
    { desc = "Highlight under cursor",
        noremap = true,
        silent = true })

map({ "n", "v", "i" }, "<F12>", function()
  if lsp and lsp.buf and lsp.buf.definition then
    lsp.buf.definition()
  else
    notify("LSP definition not available")
  end
end, { desc = "Go to Definition",
        noremap = true,
        silent = true })

-- F13–F24: Reserved for future use; mapped to <Nop> (no-op, easy to customize later)
for i = 13, 24 do
  map({ "n", "v", "i" }, "<F" .. i .. ">", "<Nop>",
        { desc = "Reserved", noremap = true, silent = true })
end

-- map({ "n", "v", "i" }, "<F24>", "0", opts)

--[[
/========================\======================================================================================
|===  PANES | BUFFERS ===|
\========================/ ]]
-- === Panes ===
-- nvim
map("n", "<A-h>", ":tabprevious<CR>")
map("n", "<A-l>", ":tabnext<CR>")
map("n", "<A-k>", ":tabmove +1<CR>")
map("n", "<A-j>", ":tabmove -1<CR>")
-- tmux
map("n", "<A-h>", ":TmuxNavigateLeft<CR>", opts)
map("n", "<A-j>", ":TmuxNavigateDown<CR>", opts)
map("n", "<A-k>", ":TmuxNavigateUp<CR>", opts)
map("n", "<A-l>", ":TmuxNavigateRight<CR>", opts)
-- zellij
map( "n", "<A-h>", "<cmd>ZellijNavigateLeftTab<cr>",
    { silent = true, desc = "navigate left or tab" }
)
map("n", "<A-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" })
map("n", "<A-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" })
map( "n", "<A-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" })

-- === Buffers ===
--map("n", "<leader>b", "<cmd>b<CR>", opts)

map("n", "<leader>bl", "<cmd>ls<CR>", opts) -- buffer list

map("n", "<leader>bt", function() -- show buffer filetype
    print("Filetype: " .. bo.filetype)
end, opts)

map("n", "<leader>bb", function() -- buffer full path
    local buf = api.nvim_get_current_buf()
    local name = api.nvim_buf_get_name(buf)
    print("Buffer name: " .. name)
end, opts)

map("n", "<leader>bn", "<cmd>bnext<CR>", opts) -- next buffer
map("n", "<leader>bp", "<cmd>bprevious<CR>", opts) -- prev buffer

map("n", "<Leader>bd", "<cmd>bd<CR>", opts) -- close current

--[[
/======================\========================================================================================
|===  FILE ACTIONS  ===|
\======================/ ]]
-- normalize pasting
map("x", "<leader>p", '"_dp')

-- replace the cursor under word, in entire buffer
map("n", "<leader>s", ":%s/\\<<C-r><C-w>>//>/<C-r><C-w>/gI<Left><Left>")

-- add execution permission
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- source current file
map("n", "<leader>o", "<cmd>source %<CR>")

--[[
/===================\===========================================================================================
|===  MOVEMENTS  ===|
\===================/ ]]
-- stand-still cursor while merging lines
map("n", "J", "mzJ`z")

-- move selected lines vertically
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Better vertical movement with wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- half page jumpings
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- duplicate lines
map("n", "<C-A-j>", "mzyyp`zj", { desc = "Duplicate line down" })
map("n", "<C-A-k>", "mzyyP`zk", { desc = "Duplicate line up" })

--[[
/======================\========================================================================================
|===  Multi-Cursor  ===|
\======================/ ]]
map({ "n", "i" }, "<A-S-j>", "<Plug>(VM-Add-Cursor-Down)", opts)
map({ "n", "i" }, "<A-S-k>", "<Plug>(VM-Add-Cursor-Up)", opts)

--[[
/====================\==========================================================================================
|===  Commenting  ===|
\====================/ ]]

--[[
/===================\===========================================================================================
|===  SEARCHING  ===|
\===================/ ]]
-- cycle through searched
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
