-- ============================================================================
-- Mini.nvim Configuration — core/plugins/mini.lua
-- ============================================================================
-- Modules: pairs (auto-pairs), surround (text objects), statusline, files,
-- align (text alignment)
-- ============================================================================

-- Mini Pairs — automatic insertion of brackets, quotes, etc.
require("mini.pairs").setup()

-- Mini Surround — add/delete/replace surrounding characters (quotes, brackets, etc.)
require("mini.surround").setup({
  mappings = {
    add = "gsa",        -- Add surrounding
    delete = "gsd",     -- Delete surrounding
    replace = "gsr",    -- Replace surrounding
    find = "gsf",       -- Find surrounding
    find_left = "gsF",  -- Find surrounding to the left
    highlight = "gsh",  -- Highlight surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
})

-- Mini Statusline — lightweight and customizable statusline
require("mini.statusline").setup({
  set_vim_settings = true,  -- Set global statusline, etc.
})

-- Mini Files — simple file explorer
require("mini.files").setup({
  mappings = {
    close       = "q",
    go_in       = "<Right>",
    go_in_plus  = "<CR>",
    go_out      = "<Left>",
    go_out_plus = "<BS>",
    reset       = "<C-r>",
    reveal_cwd  = "@",
    show_help   = "g?",
    synchronize = "=",
    trim_left   = "<",
    trim_right  = ">",
  },
  options = {
    permanent_delete = false,
    use_as_default_explorer = false,
  },
})

-- Keymap to open Mini Files at current directory
vim.keymap.set("n", "<leader>fe", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "[F]ile [E]xplorer (mini.files)" })

-- Mini Align — visually align text (e.g. around "=" or ":" or "|")
require("mini.align").setup()
