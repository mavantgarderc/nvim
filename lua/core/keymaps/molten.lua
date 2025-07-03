local map = vim.keymap.set

map("n", "<leader>ji", ":MoltenInit python3<CR>", { desc = "Init Jupyter kernel" })
map("n", "<leader>jr", ":MoltenEvaluateOperator<CR>", { desc = "Run cell under cursor" })
map("v", "<leader>jr", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "Run selection" })
map("n", "<leader>jo", ":MoltenOutput<CR>", { desc = "Show output" })
map("n", "<leader>jd", ":MoltenDelete<CR>", { desc = "Stop kernel" })
