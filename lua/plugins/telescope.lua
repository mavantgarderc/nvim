-- ============================================================================
-- Telescope Configuration — plugins/telescope.lua
-- ============================================================================
-- Fuzzy finder, pickers, and extensible file navigation
-- ============================================================================

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    -- Prefix for the search prompt and caret
    prompt_prefix = " ",  -- Updated prompt prefix
    selection_caret = " ",  -- Updated selection caret

    -- Layout Strategy and configuration
    layout_strategy = "horizontal",  -- Updated layout strategy
    layout_config = {
      horizontal = {
        preview_width = 0.5,  -- Adjusted preview width
      },
      width = 0.9,
      height = 0.85,
      preview_cutoff = 122,
    },

    -- File Ignore Patterns (added new directories to ignore)
    file_ignore_patterns = { "node_modules", ".git/", "venv/", "obj/", "bin/" },

    -- Keymapping for Telescope navigation
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
      },
    },
  },

  -- Pickers configuration
  pickers = {
    find_files = {
      hidden = true,
      follow = true,
    },
    buffers = {
      previewer = false,
      sort_mru = true,
    },
  },

  -- Extensions configuration (using fzf)
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
})

-- Optional Extension Loader (for fzf)
pcall(telescope.load_extension, "fzf")

-- Keymaps (Declarative + Discoverable via which-key)
local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })  -- New binding for diagnostics

-- ============================================================================
-- Telescope initialized
-- ============================================================================