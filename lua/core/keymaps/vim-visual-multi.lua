local map = vim.keymap.set
local g = vim.g
local cmd = vim.cmd
local api = vim.api
local opt = vim.opt
local opt_local = vim.opt_local
local fn = vim.fn

-- Functions to help with vim-visual-multi usage
local function vm_status()
  if g.VM_Selection then
    local count = g.VM_Selection.Vars.index
    print("VM: " .. count .. " cursors active")
  else
    print("VM: No active cursors")
  end
end

local function vm_clear_all()
  cmd("VMClear")
  print("VM: All cursors cleared")
end

-- Helper function to toggle VM case sensitivity
local function vm_toggle_case() cmd("VMCaseSetting") end

-- Helper function to toggle VM whole word matching
local function vm_toggle_whole_word() cmd("VMWholeWord") end

-- VM-specific autocommands for better integration
api.nvim_create_augroup("VMKeymaps", { clear = true })

-- Show VM status when entering VM mode
api.nvim_create_autocmd("User", {
  pattern = "visual_multi_start",
  group = "VMKeymaps",
  callback = function()
    print("VM: Multi-cursor mode started")
    opt_local.cursorline = true
    opt_local.cursorcolumn = true
  end,
  desc = "VM mode started",
})

-- Clean up when exiting VM mode
api.nvim_create_autocmd("User", {
  pattern = "visual_multi_exit",
  group = "VMKeymaps",
  callback = function()
    print("VM: Multi-cursor mode exited")
    opt_local.cursorline = false
    opt_local.cursorcolumn = false
  end,
  desc = "VM mode exited",
})

-- Helper function to create custom VM mappings
local function create_vm_mapping(mode, lhs, rhs, desc)
  map(mode, lhs, rhs, { desc = "Multi-cursor: " .. desc, silent = true })
end
-- Additional useful mappings for working with multiple cursors
create_vm_mapping("n", "<leader>mq", "<Esc>", "Exit multi-cursor mode")
create_vm_mapping("n", "<leader>mt", "<Plug>(VM-Toggle-Mappings)", "Toggle VM mappings")

-- Helper keymaps for VM functions
map("n", "<leader>ms", vm_status, { desc = "Multi-cursor: Show status" })
map("n", "<leader>mx", vm_clear_all, { desc = "Multi-cursor: Clear all cursors" })

-- === Keymaps ===
-- Quick access to common vim-visual-multi operations
-- map("n", "<leader>mc", "<Plug>(VM-Find-Under)",         { desc = "Multi-cursor: Find word under cursor" })
-- map("v", "<leader>mc", "<Plug>(VM-Find-Subword-Under)", { desc = "Multi-cursor: Find selection"         })
-- map("n", "<leader>M",  "<Plug>(VM-Select-All)",         { desc = "Multi-cursor: Select all occurrences" })
-- map("n", "<leader>/",  "<Plug>(VM-Start-Regex-Search)", { desc = "Multi-cursor: Start regex search"     })

-- Alternative mappings
-- map("n", "<leader>mc", "<Plug>(VM-Find-Under)",         { desc = "Multi-cursor: Find word under cursor" })
-- map("v", "<leader>mc", "<Plug>(VM-Find-Subword-Under)", { desc = "Multi-cursor: Find selection"         })
-- map("n", "<leader>ma", "<Plug>(VM-Select-All)",         { desc = "Multi-cursor: Select all occurrences" })
-- map("n", "<leader>mr", "<Plug>(VM-Start-Regex-Search)", { desc = "Multi-cursor: Start regex search"     })
-- map("n", "<leader>mv", "<Plug>(VM-Add-Cursor-At-Pos)",  { desc = "Multi-cursor: Add cursor at position" })
-- map("n", "<leader>mw", "<Plug>(VM-Add-Cursor-At-Word)", { desc = "Multi-cursor: Add cursor at word"     })

-- Visual mode mappings
-- map("v", "<C-n>",      "<Plug>(VM-Find-Subword-Under)", { desc = "Multi-cursor: Find selection"             })
-- map("v", "<leader>a",  "<Plug>(VM-Visual-Add)",         { desc = "Multi-cursor: Add visual selection"       })
-- map("v", "<leader>cf", "<Plug>(VM-Visual-Find)",        { desc = "Multi-cursor: Find visual selection"      })
-- map("v", "<leader>c",  "<Plug>(VM-Visual-Cursors)",     { desc = "Multi-cursor: Create cursors from visual" })

-- Column selection helpers
-- map("n", "<leader>mb", "<Plug>(VM-Select-BBW)",  { desc = "Multi-cursor: Select by brackets/braces/words" })
-- map("n", "<leader>ml", "<Plug>(VM-Select-Line)", { desc = "Multi-cursor: Select whole lines"              })
