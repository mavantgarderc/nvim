-- -- ============================================================================
-- -- WhichKey Configuration — plugins/whichkey.lua
-- -- ============================================================================
-- -- Keybinding helper for Neovim: Shows available keymaps in a floating window
-- -- ============================================================================

-- local wk = require("which-key")

-- -- Setup key mappings
-- wk.setup({
--   win = {
--     border = "single",  -- Border style for the floating window
--     position = "bottom", -- Display at the bottom
--   },
--   filter = {
--     missing = false,
--     spacing = 5,       -- Space between columns
--     align = "center",  -- Center keymap display
--   },
-- })

-- -- Define custom keymaps and their descriptions
-- wk.register({
--   ["<leader>"] = {
--     f = { "<cmd>Telescope find_files<cr>", "Find Files" },
--     g = { "<cmd>Neogit<cr>", "Git Status" },
--     e = { "<cmd>Neotree toggle<cr>", "Toggle File Explorer" },
--     l = { "<cmd>Lazy<cr>", "Lazy Plugin Manager" },
--     t = {
--       name = "Troubleshooting",
--       r = { "<cmd>Trouble lsp_references<cr>", "LSP References" },
--       d = { "<cmd>Trouble diagnostics<cr>", "LSP Diagnostics" },
--     },
--     b = { "<cmd>Buffers<cr>", "List Buffers" },
--     s = { "<cmd>SearchInFiles<cr>", "Search in Files" },
--     w = { "<cmd>w<cr>", "Save File" },  -- Add more common commands here if needed
--     q = { "<cmd>q!<cr>", "Quit Neovim" },  -- Add more commands if required
--   },
-- }, { prefix = "<leader>" })

-- -- Add custom keybinding for general use
-- wk.register({
--   ["<leader>q"] = { "<cmd>q!<cr>", "Quit Neovim" },
--   ["<leader>w"] = { "<cmd>w<cr>", "Save File" },
-- }, { mode = "n" })

-- -- ============================================================================
-- -- WhichKey initialized
-- -- ============================================================================
return{}