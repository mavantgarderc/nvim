--[[
/==============\================================================================================================
|=== F Keys ===|
\==============/ ]]
-- F01, n:
--      i:
--      v:
-- F02, n:
--      i:
--      v:
-- F03, n:
--      i:
--      v:
-- F04, n:
--      i:
--      v:
-- F05, n:
--      i:
--      v:
-- F06, n:
--      i:
--      v:
-- F07, n:
--      i:
--      v:
-- F08, n:
--      i:
--      v:
-- F09, n:
--      i:
--      v:
-- F10, n:
--      i:
--      v:
-- F11, n:
--      i:
--      v:
-- F12, n:
--      i:
--      v:
-- map({ "n", "v", "i" }, "<F24>", "0", opts)

local map = vim.keymap.set

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    map("i", "<F1>", "<C-[>I# <C-[>A", { buffer = true, noremap = true })
    map("i", "<F2>", "<C-[>I## <C-[>A", { buffer = true, noremap = true })
    map("i", "<F3>", "<C-[>I### <C-[>A", { buffer = true, noremap = true })
    map("i", "<F4>", "<C-[>I#### <C-[>A", { buffer = true, noremap = true })
    map("i", "<F5>", "<C-[>I##### <C-[>A", { buffer = true, noremap = true })
    map("i", "<F6>", "<C-[>I###### <C-[>A", { buffer = true, noremap = true })
  end
})


map("v", "<F2>", function()
  if vim.lsp and vim.lsp.buf and vim.lsp.buf.rename then
    vim.lsp.buf.rename()
  else
    vim.notify("LSP rename not available")
  end
end, { desc = "LSP Rename", noremap = true, silent = true, })

map({ "n", "v" }, "<F4>", function()
  if vim.lsp and vim.lsp.buf and vim.lsp.buf.code_action then
    vim.lsp.buf.code_action()
  else
    vim.notify("LSP code action not available")
  end
end, { desc = "LSP Code Action", noremap = true, silent = true, })

map("n", "<F6>", function()
  if vim.diagnostics and vim.diagnostics.config then
    local current = vim.diagnostics.config().virtual_text
    vim.diagnostics.config({ virtual_text = not current })
    vim.notify("LSP virtual text " .. (not current and "enabled" or "disabled"))
  else
    vim.notify("vim.diagnostic is not available in this session", vim.log.levels.ERROR)
  end
end, { desc = "Toggle LSP Diagnostics Virtual Text", noremap = true, silent = true, })

map("n", "<F7>", ":setlocal spell! spelllang=en_us<CR>",
  { desc = "Toggle Spellcheck", noremap = true, silent = true, })

map("n", "<F8>", ":Telescope live_grep<CR>",
  { desc = "Project Search (Telescope)", noremap = true, silent = true, })

map({ "n", "v", "i" }, "<F9>", function() vim.cmd(":LspRestart") end,
  { desc = "Restart LSP", noremap = true, silent = true, })

map("n", "<F17>", ":TSPlaygroundToggle<CR>",
  { desc = "Tree-sitter Playground", noremap = true, silent = true, })

map("i", "<F22>",
  function() vim.wo.relativenumber = not vim.wo.relativenumber end,
  { desc = "Toggle Relative Line Numbers", noremap = true, silent = true, })

map("n", "<F23>", ":TSHighlightCapturesUnderCursor<CR>",
  { desc = "Highlight under cursor", noremap = true, silent = true, })

map("n", "<F24>", function()
  if vim.lsp and vim.lsp.buf and vim.lsp.buf.definition then
    vim.lsp.buf.definition()
  else
    vim.notify("LSP definition not available")
  end
end, { desc = "Go to Definition", noremap = true, silent = true, })
