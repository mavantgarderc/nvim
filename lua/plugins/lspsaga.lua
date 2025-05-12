-- ============================================================================
-- Lspsaga Configuration — plugins/lspsaga.lua
-- ============================================================================
-- UI enhancements for LSP (code actions, rename, outline, diagnostics, etc.)
-- ============================================================================

local lspsaga = pcall(require, "lspsaga")
lspsaga.setup({
  ui = {
    border = "single",
    code_action = "💡",
    diagnostic = "🐞",
    expand = "",
    collapse = "",
    actionfix = "",
    imp_sign = "󰳛",
  },
  symbol_in_winbar = {
    enable = true,
    separator = "  ",
    hide_keyword = true,
  },
  lightbulb = {
    enable = true,
    sign = true,
    virtual_text = true,
  },
  code_action = {
    extend_gitsigns = true,
    show_server_name = true,
  },
  finder = {
    keys = {
      shuttle = "<C-s>",  -- quick switch
    },
  },
  rename = {
    in_select = false,
    auto_save = true,
  },
})

-- ============================================================================
-- Keybindings
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "gh", "<cmd>Lspsaga finder<CR>", opts)
keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", opts)
keymap("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)
keymap("n", "go", "<cmd>Lspsaga outline<CR>", opts)
keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
keymap("n", "gt", "<cmd>Lspsaga term_toggle<CR>", opts)
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
