-- ============================================================================
-- Notebook Configuration — plugins/notebook.lua
-- ============================================================================
-- Jupyter-style cell support for interactive code execution within Neovim.
-- ============================================================================

-- Plugin setup
local notebook = pcall(require, "notebook")
notebook.setup({
  -- Enable or disable the notebook interface
  enabled = true,

  -- Define a keybinding for running the current cell
  cell_run_key = "<leader>r",  -- Keybinding to run current cell

  -- Specify how cells are marked (e.g., cell headers using comments)
  cell_marker = "# %%",  -- The marker that separates cells

  -- Filetype-specific execution settings
  language_configs = {
    python = {
      execute_command = "python3",  -- Command to run Python code
      file_extension = ".py",      -- Default file extension for Python
    },
    lua = {
      execute_command = "lua",     -- Command to run Lua code
      file_extension = ".lua",     -- Default file extension for Lua
    },
  },

  -- Cell formatting and structure
  cell_structure = {
    input = "Input:",
    output = "Output:",
    error = "Error:",
  },

  -- Path to save the cell outputs (this is optional)
  save_output_path = "~/.config/nvim/cell_outputs",

  -- Keybinding to toggle cell output visibility
  toggle_output_key = "<leader>t",  -- Keybinding to toggle output display
})

-- Keybinding to run the current cell
vim.keymap.set("n", "<leader>r", function()
  notebook.run_cell()
end, { desc = "Run current cell" })

-- Keybinding to toggle output of the current cell
vim.keymap.set("n", "<leader>t", function()
  notebook.toggle_cell_output()
end, { desc = "Toggle cell output" })

-- ============================================================================
-- Notebook initialized
-- ============================================================================