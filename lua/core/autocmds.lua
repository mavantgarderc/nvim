vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*/lsp/*.lua", "*/plugins/lsp.lua" },
	callback = function()
		vim.notify("LSP config changed, restart Neovim or run :LspRestart", vim.log.levels.INFO)
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*/lsp/servers/*.lua" },
	callback = function()
		vim.cmd("LspRestart")
		vim.notify("LSP restarted", vim.log.levels.INFO)
	end,
})
