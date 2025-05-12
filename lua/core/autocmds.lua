-- ============================================================================
-- Auto Commands — core/autocmds.lua
-- ============================================================================
-- Automate context-based behavior using Neovim's event hooks:
-- ▸ FileType-specific rules
-- ▸ Editor lifecycle events
-- ▸ UX enhancements (restore cursor, auto-format, etc.)
-- ============================================================================

local api = vim.api
local augroup = api.nvim_create_augroup

-- Create centralized augroups
local general_group = augroup("General", { clear = true })
local lsp_group = augroup("LSP", { clear = true })
local terminal_group = augroup("Terminal", { clear = true })

-- ============================================================================
-- CURSOR POSITION RESTORE ----------------------------------------------------
api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
  desc = "Restore last cursor position on reopen",
  callback = function()
    local mark = vim.fn.line([['"]])
    if mark > 1 and mark <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- ============================================================================
-- TRIM TRAILING WHITESPACE ---------------------------------------------------
api.nvim_create_autocmd("BufWritePre", {
  group = general_group,
  desc = "Trim trailing whitespace before save",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- ============================================================================
-- TEXT FILE SETTINGS ---------------------------------------------------------
api.nvim_create_autocmd("FileType", {
  group = general_group,
  desc = "Enable spell and wrap for prose/text",
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

-- ============================================================================
-- TERMINAL MODE SETTINGS -----------------------------------------------------
api.nvim_create_autocmd("TermOpen", {
  group = terminal_group,
  desc = "Terminal starts in insert mode",
  pattern = "term://*",
  command = "startinsert",
})

api.nvim_create_autocmd("TermOpen", {
  group = terminal_group,
  desc = "Hide line numbers in terminal",
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- ============================================================================
-- LSP FORMAT ON SAVE (to be configured per-client) ---------------------------
-- ▸ This is a placeholder. Actual logic is registered from `core/lsp/init.lua`
-- ============================================================================
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = lsp_group,
--   pattern = "*",
--   callback = function()
--     vim.lsp.buf.format({ async = true })
--   end,
-- })

-- ============================================================================
-- UX POLISH — HIGHLIGHT ON YANK ----------------------------------------------
api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ============================================================================
-- ⚡ Autocommands configured
-- ============================================================================