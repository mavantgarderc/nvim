local map = vim.keymap.set
local refact = require("refactoring")
local opts = { noremap = true, silent = true }

map("x", "<leader>rr", function()
  refact.select_refactor()
end, vim.tbl_extend("force", opts, { desc = "Refactor selection" }))

map("n", "<leader>rI", function()
  refact.debug.printf({ below = false })
end, vim.tbl_extend("force", opts, { desc = "Insert debug print" }))

map("n", "<leader>rC", function()
  refact.debug.cleanup({})
end, vim.tbl_extend("force", opts, { desc = "Cleanup debug prints" }))

map("n", "<leader>rV", function()
  refact.debug.print_var({})
end, vim.tbl_extend("force", opts, { desc = "Print var under cursor" }))
