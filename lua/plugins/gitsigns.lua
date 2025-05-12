-- ============================================================================
-- Gitsigns Configuration — plugins/gitsigns.lua
-- ============================================================================
-- Git integration in the sign column: Git diffs, blame, and actions
-- ============================================================================

local gitsigns = pcall(require, "gitsigns")

gitsigns.setup({
  signs = {
    add          = { hl = "GitGutterAdd", text = "┃", numhl = "GitGutterAddNr", linehl = "GitGutterAddLn" },
    change       = { hl = "GitGutterChange", text = "┃", numhl = "GitGutterChangeNr", linehl = "GitGutterChangeLn" },
    delete       = { hl = "GitGutterDelete", text = "⟜", numhl = "GitGutterDeleteNr", linehl = "GitGutterDeleteLn" },
    topdelete    = { hl = "GitGutterDelete", text = "⟘", numhl = "GitGutterDeleteNr", linehl = "GitGutterDeleteLn" },
    changedelete = { hl = "GitGutterChange", text = "⟠", numhl = "GitGutterChangeNr", linehl = "GitGutterChangeLn" },
  },

  numhl = true,
  linehl = false,
  word_diff = false,

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Navigation through hunk regions
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]h", ":Gitsigns next_hunk<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[h", ":Gitsigns prev_hunk<CR>", { noremap = true })

    -- Actions within hunk regions
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hs", ":Gitsigns stage_hunk<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hr", ":Gitsigns reset_hunk<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hS", ":Gitsigns stage_buffer<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>hR", ":Gitsigns reset_buffer<CR>", { noremap = true })
  end,
})

-- ============================================================================
-- Gitsigns initialized
-- ============================================================================