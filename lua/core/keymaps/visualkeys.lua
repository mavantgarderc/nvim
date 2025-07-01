--[[
/==============\================================================================================================
|=== F Keys ===|
\==============/ ]]
-- F01, n:
--      i: MD: H1
--      v:
-- F02, n:
--      i: MD: H2
--      v: LSP Rename
-- F03, n: LSP Format
--      i: MD: H3
--      v:
-- F04, n: LSP Code action
--      i: MD: H4
--      v:
-- F05, n: Toggle tree-sitter playground
--      i: MD: H5
--      v:
-- F06, n: Toggle Diagnostics Virtual Text
--      i: MD: H6
--      v:
-- F07, n: Spellcheck toggle
--      i:
--      v:
-- F08, n: Telescope live grep (project search)
--      i:
--      v:
-- F09, n: Restart LSP
--      i:
--      v:
-- F10, n:
--      i: Toggle Relative Line Numbers
--      v:
-- F11, n: Treesitter highlight floater
--      i:
--      v:
-- F12, n: LSP Go to Definition
--      i:
--      v:
-- map({ "n", "v", "i" }, "<F24>", "0", opts)

local map = vim.keymap.set
local log = vim.log
local lsp = vim.lsp
local notify = vim.notify
local diagnostics = vim.diagnostic
local cmd = vim.cmd
local api = vim.api
local wo = vim.wo

api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        map("i", "<F1>", "# ",      { buffer = true, noremap = true})
        map("i", "<F2>", "## ",     { buffer = true, noremap = true})
        map("i", "<F3>", "### ",    { buffer = true, noremap = true})
        map("i", "<F4>", "#### ",   { buffer = true, noremap = true})
        map("i", "<F5>", "##### ",  { buffer = true, noremap = true})
        map("i", "<F6>", "###### ", { buffer = true, noremap = true})
    end
})


map( "v", "<F2>", function()
    if lsp and lsp.buf and lsp.buf.rename then
        lsp.buf.rename()
    else
        notify("LSP rename not available")
    end
end, { desc = "LSP Rename", noremap = true, silent = true, })

map({ "n", "v"}, "<F3>", function()
    if lsp and lsp.buf and lsp.buf.format then
        lsp.buf.format()
    else
        notify("LSP format not available")
    end
end, { desc = "LSP format buffer/selection", noremap = true, silent = true, })

map({ "n", "v"}, "<F4>", function()
    if lsp and lsp.buf and lsp.buf.code_action then
        lsp.buf.code_action()
    else
        notify("LSP code action not available")
    end
end, { desc = "LSP Code Action", noremap = true, silent = true, })

map("n", "<F6>", function()
    if diagnostics and diagnostics.config then
        local current = diagnostics.config().virtual_text
        diagnostics.config({ virtual_text = not current })
        notify("LSP virtual text " .. (not current and "enabled" or "disabled"))
    else
        notify("vim.diagnostic is not available in this session", log.levels.ERROR)
    end
end, { desc = "Toggle LSP Diagnostics Virtual Text", noremap = true, silent = true, })

map("n", "<F7>", ":setlocal spell! spelllang=en_us<CR>",
    { desc = "Toggle Spellcheck", noremap = true, silent = true, })

map("n", "<F8>", ":Telescope live_grep<CR>",
    { desc = "Project Search (Telescope)", noremap = true, silent = true, })

map({ "n", "v", "i" }, "<F9>", function() cmd(":LspRestart") end,
    { desc = "Restart LSP", noremap = true, silent = true, })

map("i", "<F10>",
    function() wo.relativenumber = not wo.relativenumber end,
    { desc = "Toggle Relative Line Numbers", noremap = true, silent = true, })

map("n", "<F12>", function()
    if lsp and lsp.buf and lsp.buf.definition then
        lsp.buf.definition()
    else
        notify("LSP definition not available")
    end
end, { desc = "Go to Definition", noremap = true, silent = true, })

map("n", "<F23>", ":TSHighlightCapturesUnderCursor<CR>",
    { desc = "Highlight under cursor", noremap = true, silent = true, })

map("n", "<F17>", ":TSPlaygroundToggle<CR>",
    { desc = "Tree-sitter Playground", noremap = true, silent = true, })
