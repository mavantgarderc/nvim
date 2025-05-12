-- ============================================================================
-- Lualine Configuration — plugins/lualine.lua
-- ============================================================================
-- Status line for Neovim, highly customizable and fast
-- ============================================================================
local lualine = pcall(require, "lualine")
lualine.setup({
  options = {
    icons_enabled = true,
    theme = 'gruvbox',  -- Change this to your desired theme
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'NvimTree', 'neo-tree', 'terminal', 'dashboard' },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename', 'filetype' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { 'fugitive', 'nvim-tree', 'quickfix', 'fuzzyfinder' }
})

-- ============================================================================
-- Lualine initialized
-- ============================================================================