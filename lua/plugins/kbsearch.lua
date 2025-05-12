-- ============================================================================
-- KBSearch Configuration — plugins/kbsearch.lua
-- ============================================================================
-- In-editor search for keybindings and commands.
-- ============================================================================

local kbsearch = pcall(require, "kbsearch")

-- Configure KBSearch for keybinding lookup
kbsearch.setup({
  -- Keybinding to trigger keybinding search
  trigger_key = "<leader>k",  -- Trigger the search for keybindings

  -- Show all keybindings in the search result
  show_all = true,  -- Display all available keymaps when searching

  -- The default search layout
  layout = "flex",  -- Layout style for displaying results (can be 'flex', 'vertical', etc.)

  -- Customize search filters (optional)
  search_filters = {
    commands = true, -- Include command search
    keymaps = true,  -- Include keymap search
  },

  -- Keybinding action to search for a keybinding
  action = function(query)
    vim.cmd("WhichKey " .. query)
  end,
})

-- Keybinding to search for keymaps and commands
vim.keymap.set("n", "<leader>k", function()
  kbsearch.search_keybindings()
end, { desc = "Search Keybindings" })

-- ============================================================================
-- KBSearch initialized
-- ============================================================================