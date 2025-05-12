-- ============================================================================
-- Statusline Configuration — ui/statusline.lua
-- ============================================================================
-- Customize the status line and navigation using lualine and nvim-navic.
-- ============================================================================
local line = pcall(require, "lualine")
line.setup({
  options = {
    icons_enabled = true,
    theme = "tokyonight",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "neo-tree", "terminal" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename", "filetype" },
    lualine_x = { "encoding", "fileformat", "location" },
    lualine_y = { "progress" },
    lualine_z = { "percent" },
  },
  extensions = { "fugitive", "neo-tree" },
})


-- Initialize lualine (statusline plugin)
local lualine = pcall(require, "lualine")
lualine.setup({
  options = {
    theme = "gruvbox",  -- Choose your theme for the status line
    section_separators = {"", ""},  -- Set separators between sections
    component_separators = {"", ""},  -- Set separators within sections
  },
  sections = {
    -- Left section
    lualine_a = {"mode"},  -- Show current mode (e.g., Normal, Insert)
    lualine_b = {"branch"},  -- Show Git branch
    lualine_c = {"filename"},  -- Show the current file name
    lualine_x = {
      "filetype",  -- Show file type (e.g., python, lua)
      "diagnostics",  -- Show LSP diagnostics (e.g., errors, warnings)
      "encoding",  -- Show file encoding (e.g., UTF-8)
    },
    lualine_y = {"progress"},  -- Show progress (line/total lines)
    lualine_z = {"location"},  -- Show current line and column number
  },
  extensions = {"fugitive", "neo-tree"},  -- Enable extensions (e.g., Git, file explorer)
})

-- Initialize nvim-navic (for LSP navigation)
local nvim_navic = pcall(require, "nvim-navic")
nvim_navic.setup({
  separator = " > ",  -- Separator between navigation levels
  depth_limit = 3,    -- Limit the depth of navigation context
  icons = {
    File = "",
    Module = "",
    Namespace = "",
    Package = "",
    Class = "ﴯ",
    Method = "",
    Property = "",
    Field = "",
    Constructor = "",
    Enum = "",
    Interface = "ﰮ",
    Function = "",
    Variable = "",
    Constant = "",
    String = "",
    Number = "",
    Boolean = "⊨",
    Array = "",
    Object = "",
    Key = "",
    Null = "NULL",
    EnumMember = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
})

-- Keybinding to toggle the statusline
vim.keymap.set("n", "<leader>ss", function()
  lualine.toggle()  -- Toggle the statusline visibility
end, { desc = "Toggle Statusline" })

-- ============================================================================
-- Statusline initialized
-- ============================================================================

-- ============================================================================
-- Statusline Configuration — ui/statusline.lua
-- ============================================================================
