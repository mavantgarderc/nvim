-- ============================================================================
-- Trouble.nvim Configuration — plugins/trouble.lua
-- ============================================================================
-- A pretty diagnostics, references, quickfix and location list
-- ============================================================================

require("trouble").setup({
  position = "bottom",           -- Bottom pane
  height = 12,                   -- Height of the Trouble window
  icons = true,                  -- Use devicons
  mode = "workspace_diagnostics",-- Default mode
  fold_open = "",
  fold_closed = "",
  group = true,                  -- Group results by file
  padding = true,
  signs = {
    error = "",
    warning = "",
    hint = "",
    information = "",
  },
  use_diagnostic_signs = false,  -- Use signs defined above
})
