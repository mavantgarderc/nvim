-- ============================================================================
-- Highlights Configuration — ui/highlights.lua
-- ============================================================================
-- Customize UI element colors, including statusline, current window, and more.
-- ============================================================================

-- Set custom highlight groups for the statusline
vim.cmd([[
  highlight StatusLine guifg=#FFFFFF guibg=#1E1E1E gui=bold
  highlight StatusLineNC guifg=#888888 guibg=#1E1E1E
  highlight LualineCNormal guifg=#FFFFFF guibg=#2E2E2E
  highlight LualineBNormal guifg=#F1FA8C guibg=#3E3E3E
  highlight LualineAInsert guifg=#FF5555 guibg=#282828
  highlight LualineAVisual guifg=#8BE9FD guibg=#282828
  highlight LualineALine guifg=#50FA7B guibg=#282828
  highlight LualineX guifg=#FF79C6 guibg=#282828
  highlight LualineY guifg=#F8F8F2 guibg=#282828
]])

-- Set custom highlight for the cursorline (active line in current window)
vim.cmd([[
  highlight CursorLine guibg=#2A2A2A
]])

-- Set custom highlight for search results
vim.cmd([[
  highlight Search guibg=#FFB86C guifg=#282828
]])

-- Set custom highlight for line numbers
vim.cmd([[
  highlight LineNr guifg=#444444
]])

-- Set custom highlight for current line number
vim.cmd([[
  highlight CursorLineNr guifg=#FF79C6
]])

-- ============================================================================
-- Highlights initialized
-- ============================================================================