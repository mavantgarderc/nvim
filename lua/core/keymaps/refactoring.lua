local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local tbl_extend = vim.tbl_extend

map("x", "<leader>rr", function()
  require("refactoring").select_refactor()
end, tbl_extend("force", opts, { desc = "Refactor selection" }))

map("n", "<leader>rI", function()
  require("refactoring").debug.printf({ below = false })
end, tbl_extend("force", opts, { desc = "Insert debug print" }))

map("n", "<leader>rC", function()
  require("refactoring").debug.cleanup({})
end, tbl_extend("force", opts, { desc = "Cleanup debug prints" }))

map("n", "<leader>rV", function()
  require("refactoring").debug.print_var({})
end, tbl_extend("force", opts, { desc = "Print var under cursor" }))
