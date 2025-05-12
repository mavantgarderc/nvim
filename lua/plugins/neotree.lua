-- ============================================================================
-- NeoTree Configuration — plugins/neotree.lua
-- ============================================================================
-- File explorer with tree view, git status indicators, and more
-- ============================================================================

require("neo-tree").setup({
  close_if_last_window = true,  -- Close NeoTree if it's the last window
  popup_border_style = "single",
  enable_git_status = true,     -- Show Git status indicators in file tree
  enable_diagnostics = true,    -- Show diagnostic signs
  default_component_configs = {
    indent = { padding = 1 },    -- File tree indentation
    icon = {
      folder_empty = "",         -- Icon for empty folders
      folder_open = "",          -- Icon for open folders
      folder_closed = "",        -- Icon for closed folders
    },
  },
  window = {
    width = 40,                  -- Set the width of the tree view
    mappings = {
      ["<space>"] = "toggle_node",   -- Toggle folder nodes
      ["<cr>"] = "open",             -- Open a file
      ["<leader>f"] = "filter_by_extension",  -- Filter files by extension
    },
  },
  filesystem = {
    follow_current_file = true,    -- Focus on the file you're editing
    hijack_netrw = true,           -- Hijack netrw file explorer
    use_libuv_file_watcher = true, -- Enable file system watcher
  },
  git_status = {
    symbols = {
      added = "✚",                -- Added file symbol
      modified = "✎",             -- Modified file symbol
      deleted = "✘",              -- Deleted file symbol
      renamed = "➜",              -- Renamed file symbol
    },
  },
})

-- Keybindings for toggling NeoTree file explorer
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle NeoTree" })

-- ============================================================================
-- NeoTree initialized
-- ============================================================================