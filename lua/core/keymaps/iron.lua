local map = vim.keymap.set

map("n", "<leader>mcc", "iron_repl_mark_motion<CR>", { desc = "Iron REPL Mark Motion" })
map("n", "<leader>rs", ":IronRepl<CR>", { desc = "Start Iron REPL" })
map("n", "<leader>rr", ":IronRestart<CR>", { desc = "Restart Iron REPL" })
map("n", "<leader>rf", ":IronFocus<CR>", { desc = "Focus Iron REPL" })
map("n", "<leader>rh", ":IronHide<CR>", { desc = "Hide Iron REPL" })
