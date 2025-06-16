--[[
/=================================\=============================================================================
|===  LOCAL VARIABLE MAPPINGS  ===|
\=================================/ ]]
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
local wo = vim.wo

local opts = {
    noremap = true,
    silent = true,
}

--[[
/================\=============================================================================================
|===  BASICS  ===|
\===============/ ]]
--[[
And for them whom following Grimnir's path, The Allfather
obliged be armored by 100% layout seiðr... ]]

-- Insert Mode Movement
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Comments
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- stand-still cursor while merging lines
map("n", "J", "mzJ`z")

-- move selected lines vertically
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Better vertical movement with wrapped lines
map({ "n", "v", "i" }, "<Find>", "0", opts)
map({ "n", "v", "i" }, "<Select>", "$", opts)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- half page jumpings
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- duplicate lines
map("n", "<C-A-j>", "mzyyp`zj", { desc = "Duplicate line down" })
map("n", "<C-A-k>", "mzyyP`zk", { desc = "Duplicate line up" })

-- searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<Esc>", ":nohlsearch<CR>", opts)
--map("n", "<Esc>", ":noh<CR>", opts)

-- Multi-Cursor
map({ "n", "i" }, "<A-S-j>", "<Plug>(VM-Add-Cursor-Down)", opts)
map({ "n", "i" }, "<A-S-k>", "<Plug>(VM-Add-Cursor-Up)", opts)

--[[
/========================\======================================================================================
|===  PANES | BUFFERS ===|
\========================/ ]]
-- === NVIM ===
-- Buffers
map("n", "<leader>bl", ":ls<CR>", opts)
map("n", "<leader>bt", function() print("Filetype: " .. bo.filetype) end, opts)
map("n", "<leader>bb", function() print(api.nvim_buf_get_name(api.nvim_get_current_buf())) end, opts)
map("n", "<leader>bn", ":bnext<CR>", opts)
map("n", "<leader>bp", ":bprevious<CR>", opts)
map("n", "<Leader>bd", ":bd<CR>", opts)
-- Panes
map("n", "<leader>h", "<C-w>h", { desc = "switch window left" })
map("n", "<leader>l", "<C-w>l", { desc = "switch window right" })
map("n", "<leader>j", "<C-w>j", { desc = "switch window down" })
map("n", "<leader>k", "<C-w>k", { desc = "switch window up" })
-- Resize Panes
map("n", "<C-A-h>", ":vertical resize -5<CR>", { desc = "Decrease window width" })
map("n", "<C-A-l>", ":vertical resize +5<CR>", { desc = "Increase window width" })
map("n", "<C-A-j>", ":resize -5<CR>", { desc = "Decrease window height" })
map("n", "<C-A-k>", ":resize +5<CR>", { desc = "Increase window height" })

-- === Terminal Multiplexer ===
map("n", "<A-h>", ":ZellijNavigateLeftTab<cr>", { silent = true, desc = "navigate left or tab" })
map("n", "<A-j>", ":ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" })
map("n", "<A-k>", ":ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" })
map("n", "<A-l>", ":ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" })

--[[
/======================\========================================================================================
|===  FILE ACTIONS  ===|
\======================/ ]]
-- normalize pasting
map("x", "<leader>p", '"_dp')

-- replace the cursor under word, in entire buffer
map("n", "<leader>s", ":%s/\\<<C-r><C-w>>\\>//gI<Left><Left>")

-- add execution permission
map("n", "<leader>x", ":!chmod +x %<CR>", { silent = true })

-- source current file
map("n", "<leader>o", ":so %<CR>")

--[[
/==============\================================================================================================
|=== F Keys ===|
\==============/ ]]
-- F01, n:
--      i:
--      v: Help
-- F02, n: LSP Rename
--      i: LSP Rename
--      v: LSP Rename
-- F03, n: LSP Format
--      i:
--      v:
-- F04, n: LSP Code action
--      i:
--      v:
-- F05, n: Toggle tree-sitter playground
--      i:
--      v:
-- F06, n: Toggle Diagnostics Virtual Text
--      i:
--      v:
-- F07, n: Spellcheck toggle
--      i:
--      v:
-- F08, n: Telescope live grep (project search)
--      i: Telescope live grep (project search)
--      v:
-- F09, n: Restart LSP
--      i:
--      v:
-- F10, n: Toggle Relative Line Numbers
--      i:
--      v:
-- F11, n: Treesitter highlight floater
--      i:
--      v:
-- F12, n: LSP Go to Definition
--      i:
--      v:
-- F13, n:
--      i:
--      v:
-- F14, n:
--      i:
--      v:
-- F15, n:
--      i:
--      v:
-- F16, n:
--      i:
--      v:
-- F17, n:
--      i:
--      v:
-- F18, n:
--      i:
--      v:
-- F19, n:
--      i:
--      v:
-- F20, n:
--      i:
--      v:
-- F21, n:
--      i:
--      v:
-- F22, n:
--      i:
--      v:
-- F23, n:
--      i:
--      v:
-- F24, n:
--      i:
--      v:

map({ "n", "v", "i" }, "<F1>", ":help<CR>", {
    desc = "Help",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F2>", function()
    if lsp and lsp.buf and lsp.buf.rename then
        lsp.buf.rename()
    else
        notify("LSP rename not available")
    end
end, {
    desc = "LSP Rename",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F3>", function()
    if lsp and lsp.buf and lsp.buf.format then
        lsp.buf.format()
    else
        notify("LSP format not available")
    end
end, {
    desc = "LSP format buffer/selection",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F4>", function()
    if lsp and lsp.buf and lsp.buf.code_action then
        lsp.buf.code_action()
    else
        notify("LSP code action not available")
    end
end, {
    desc = "LSP Code Action",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F5>", ":TSPlaygroundToggle<CR>", {
    desc = "Tree-sitter Playground",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F6>", function()
    if diagnostics and diagnostics.config then
        local current = diagnostics.config().virtual_text
        diagnostics.config({ virtual_text = not current })
        notify("LSP virtual text " .. (not current and "enabled" or "disabled"))
    else
        notify("vim.diagnostic is not available in this session", log.levels.ERROR)
    end
end, {
    desc = "Toggle LSP Diagnostics Virtual Text",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F7>", ":setlocal spell! spelllang=en_us<CR>", {
    desc = "Toggle Spellcheck",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F8>", ":Telescope live_grep<CR>", {
    desc = "Project Search (Telescope)",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F9>", function() cmd("LspRestart") end, {
    desc = "Restart LSP",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F10>", function() wo.relativenumber = not wo.relativenumber end, {
    desc = "Toggle Relative Line Numbers",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F11>", ":TSHighlightCapturesUnderCursor<CR>", {
    desc = "Highlight under cursor",
    noremap = true,
    silent = true,
})

map({ "n", "v", "i" }, "<F12>", function()
    if lsp and lsp.buf and lsp.buf.definition then
        lsp.buf.definition()
    else
        notify("LSP definition not available")
    end
end, {
    desc = "Go to Definition",
    noremap = true,
    silent = true,
})

-- map({ "n", "v", "i" }, "<F24>", "0", opts)
