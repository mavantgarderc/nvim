local v = vim.v
local fn = vim.fn
local map = vim.keymap.set
local opt = vim.opt
local cmd = vim.cmd
local notify = vim.notify

-- ========================================
-- Native Vim Fold Commands (Priority)
-- ========================================

-- Basic folding
map("n", "zf", "zf", { desc = "Create fold" })
map("v", "zf", "zf", { desc = "Create fold from selection" })
map("n", "zd", "zd", { desc = "Delete fold under cursor" })
map("n", "zD", "zD", { desc = "Delete all folds in current line" })
map("n", "zE", "zE", { desc = "Eliminate all folds" })

-- Opening folds
map("n", "zo", "zo", { desc = "Open fold under cursor" })
map("n", "zO", "zO", { desc = "Open all folds under cursor" })
map("n", "zc", "zc", { desc = "Close fold under cursor" })
map("n", "zC", "zC", { desc = "Close all folds under cursor" })
map("n", "za", "za", { desc = "Toggle fold under cursor" })
map("n", "zA", "zA", { desc = "Toggle all folds under cursor" })

-- Global fold operations
map("n", "zr", "zr", { desc = "Reduce fold level (open one level)" })
map("n", "zR", "zR", { desc = "Open all folds" })
map("n", "zm", "zm", { desc = "Fold more (close one level)" })
map("n", "zM", "zM", { desc = "Close all folds" })

-- Fold navigation
map("n", "zj", "zj", { desc = "Move to next fold" })
map("n", "zk", "zk", { desc = "Move to previous fold" })
map("n", "[z", "[z", { desc = "Move to start of current fold" })
map("n", "]z", "]z", { desc = "Move to end of current fold" })

-- Fold view operations
map("n", "zv", "zv", { desc = "View cursor line (open folds)" })
map("n", "zx", "zx", { desc = "Update folds" })
map("n", "zX", "zX", { desc = "Undo manually opened/closed folds" })

-- Fold level operations
map("n", "z1", function() opt.foldlevel = 1 end, { desc = "Set fold level to 1" })
map("n", "z2", function() opt.foldlevel = 2 end, { desc = "Set fold level to 2" })
map("n", "z3", function() opt.foldlevel = 3 end, { desc = "Set fold level to 3" })
map("n", "z4", function() opt.foldlevel = 4 end, { desc = "Set fold level to 4" })
map("n", "z5", function() opt.foldlevel = 5 end, { desc = "Set fold level to 5" })
map("n", "z6", function() opt.foldlevel = 6 end, { desc = "Set fold level to 6" })
map("n", "z7", function() opt.foldlevel = 7 end, { desc = "Set fold level to 7" })
map("n", "z8", function() opt.foldlevel = 8 end, { desc = "Set fold level to 8" })
map("n", "z9", function() opt.foldlevel = 9 end, { desc = "Set fold level to 9" })
map("n", "z0", function() opt.foldlevel = 0 end, { desc = "Set fold level to 0" })

-- ========================================
-- Enhanced Fold Operations
-- ========================================

-- Leader-based fold operations for easier access
map("n", "<leader>zf", "zf", { desc = "Create fold" })
map("v", "<leader>zf", "zf", { desc = "Create fold from selection" })
map("n", "<leader>zd", "zd", { desc = "Delete fold under cursor" })
map("n", "<leader>zD", "zD", { desc = "Delete all folds in current line" })
map("n", "<leader>zE", "zE", { desc = "Eliminate all folds" })

-- Quick fold level adjustments
map("n", "<leader>z+", "zr", { desc = "Reduce fold level (open one level)" })
map("n", "<leader>z-", "zm", { desc = "Fold more (close one level)" })
map("n", "<leader>zR", "zR", { desc = "Open all folds" })
map("n", "<leader>zM", "zM", { desc = "Close all folds" })

-- Fold method switching
map("n", "<leader>zmi", function() opt.foldmethod = "indent" end, { desc = "Set fold method to indent" })
map("n", "<leader>zms", function() opt.foldmethod = "syntax" end, { desc = "Set fold method to syntax" })
map("n", "<leader>zmm", function() opt.foldmethod = "manual" end, { desc = "Set fold method to manual" })
map("n", "<leader>zme", function() opt.foldmethod = "expr" end, { desc = "Set fold method to expr" })
map("n", "<leader>zmk", function() opt.foldmethod = "marker" end, { desc = "Set fold method to marker" })
map("n", "<leader>zmd", function() opt.foldmethod = "diff" end, { desc = "Set fold method to diff" })

-- ========================================
-- Fold Utility Functions
-- ========================================

-- Toggle fold column
map("n", "<leader>zfc", function()
  local current = opt.foldcolumn:get()
  if current == "0" then
    opt.foldcolumn = "4"
    notify("Fold column enabled")
  else
    opt.foldcolumn = "0"
    notify("Fold column disabled")
  end
end, { desc = "Toggle fold column" })

-- Show fold info
map("n", "<leader>zfi", function()
  local foldlevel  = opt.foldlevel:get()
  local foldmethod = opt.foldmethod:get()
  local foldcolumn = opt.foldcolumn:get()
  local foldenable = opt.foldenable:get()

  local info = string.format(
    "Fold Info:\n• Method: %s\n• Level: %d\n• Column: %s\n• Enabled: %s",
    foldmethod, foldlevel, foldcolumn, foldenable and "Yes" or "No"
  )
  notify(info)
end, { desc = "Show fold info" })

-- Toggle folding on/off
map("n", "<leader>zt", function()
  opt.foldenable = not opt.foldenable:get()
  local status = opt.foldenable:get() and "enabled" or "disabled"
  notify("Folding " .. status)
end, { desc = "Toggle folding" })

-- ========================================
-- Advanced Fold Operations
-- ========================================

-- Fold all functions (for programming languages)
map("n", "<leader>zff", function()
  cmd("normal! zE")  -- Clear existing folds
  cmd("g/^\\s*function\\|^\\s*def\\|^\\s*class/,/^}/fold")
end, { desc = "Fold all functions" })

-- Fold all comments
map("n", "<leader>zcc", function()
  cmd("normal! zE")  -- Clear existing folds
  cmd("g/^\\s*\\/\\*\\|^\\s*\\/\\/\\|^\\s*#\\|^\\s*\"/,/\\*\\/\\|$/fold")
end, { desc = "Fold all comments" })

-- Save and restore fold state
map("n", "<leader>zs", function()
  cmd("mkview")
  notify("Fold state saved")
end, { desc = "Save fold state" })

map("n", "<leader>zl", function()
  cmd("loadview")
  notify("Fold state loaded")
end, { desc = "Load fold state" })

-- ========================================
-- Fold Text Customization
-- ========================================

-- Custom fold text function
local function custom_fold_text()
  local line = fn.getline(v.foldstart)
  local line_count = v.foldend - v.foldstart + 1
  local indent = string.rep(" ", fn.indent(v.foldstart))

  -- Clean up the line
  line = line:gsub("^%s*", ""):gsub("{%s*$", ""):gsub("/%*.*%*/$", "")

  return string.format("%s%s ... [%d lines]", indent, line, line_count)
end

-- Set custom fold text
opt.foldtext = "v:lua.require('core.keymaps.folds').custom_fold_text()"

-- Export for foldtext
return {
  custom_fold_text = custom_fold_text
}
