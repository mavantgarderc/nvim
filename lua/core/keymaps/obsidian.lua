local M = {}

function M.set_keymaps(bufnr)
	local map = vim.keymap.set

	map("n", "<leader>obo", ":ObsidianOpen<CR>", { desc = "Open vault", buffer = bufnr })
	map("n", "<leader>obn", ":ObsidianNew<CR>", { desc = "New note", buffer = bufnr })
	map("n", "<leader>obq", ":ObsidianQuickSwitch<CR>", { desc = "Quick switch", buffer = bufnr })
	map("n", "<leader>obt", ":ObsidianToday<CR>", { desc = "Today's note", buffer = bufnr })
	map("n", "<leader>oby", ":ObsidianYesterday<CR>", { desc = "Yesterday's note", buffer = bufnr })
	map("n", "<leader>obb", ":ObsidianBacklinks<CR>", { desc = "Backlinks", buffer = bufnr })
	map("n", "<leader>obs", ":ObsidianSearch<CR>", { desc = "Search notes", buffer = bufnr })
	map("n", "<leader>obf", ":ObsidianFollowLink<CR>", { desc = "Follow link", buffer = bufnr })
	map("n", "<leader>obd", ":ObsidianDailies<CR>", { desc = "List dailies", buffer = bufnr })
	map("n", "<leader>obl", ":ObsidianLink<CR>", { desc = "Link to note", buffer = bufnr })
	map("v", "<leader>obl", ":ObsidianLinkNew<CR>", { desc = "Link visual selection", buffer = bufnr })
	map("n", "<leader>obr", ":ObsidianRename<CR>", { desc = "Rename note", buffer = bufnr })
	map("n", "<leader>obm", ":ObsidianTemplate<CR>", { desc = "Insert template", buffer = bufnr })
	map("n", "<leader>obi", ":ObsidianPasteImg<CR>", { desc = "Paste image", buffer = bufnr })
	map("n", "<leader>obc", ":ObsidianCheck<CR>", { desc = "Check note", buffer = bufnr })
end

return M
