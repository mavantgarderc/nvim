local map = vim.keymap.set

map("n", "<leader>X", ":!chmod +x %<CR>", { silent = true, desc = "Execution permission to the current file" })

map("n", "<leader>oo", function()
	vim.cmd("wall")
	local filetype = vim.bo.filetype
	if filetype == "lua" then
		vim.cmd("source %")
		vim.notify(" 󱓎 ", vim.log.levels.INFO)
	else
		vim.notify(" 󱓎 ", vim.log.levels.INFO)
	end
end, { desc = "Save all; source if Lua" })

-- map("n", "<leader>o<leader>o", ":wa<CR>:qa", { desc = "Save all, then quit; confirmation needed" })
