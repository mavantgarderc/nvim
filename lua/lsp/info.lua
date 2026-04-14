local M = {}
local commands_registered = false

function M.show_server_info()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.INFO)
		return
	end

	local lines = { "# LSP Server Information\n" }
	for _, client in ipairs(clients) do
		table.insert(lines, string.format("## %s", client.name))
		table.insert(lines, string.format("- ID: %d", client.id))
		table.insert(lines, string.format("- Root: %s", client.config.root_dir or "N/A"))
		table.insert(lines, string.format("- Filetypes: %s", table.concat(client.config.filetypes or {}, ", ")))

		table.insert(lines, "### Capabilities:")
		local caps = client.server_capabilities or {}
		local capability_names = {}
		for key, value in pairs(caps) do
			if type(value) == "boolean" and value then
				table.insert(capability_names, key)
			end
		end
		table.sort(capability_names)
		for _, key in ipairs(capability_names) do
			table.insert(lines, string.format("- %s", key))
		end
		table.insert(lines, "")
	end

	local max_width = math.max(60, math.floor(vim.o.columns * 0.6))
	local max_height = math.max(8, math.min(#lines + 1, math.floor(vim.o.lines * 0.75)))
	local buf, win = vim.lsp.util.open_floating_preview(lines, "markdown", {
		border = "rounded",
		max_width = max_width,
		max_height = max_height,
		focusable = true,
	})

	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.bo[buf].filetype = "markdown"
		local opts = { buffer = buf, nowait = true, silent = true }
		vim.keymap.set("n", "q", function()
			if win and vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end, opts)
		vim.keymap.set("n", "<Esc>", function()
			if win and vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end, opts)
	end

	return buf, win, lines
end

function M.setup()
	if commands_registered then
		return
	end

	vim.api.nvim_create_user_command("LspInfo", function()
		M.show_server_info()
	end, { desc = "Show attached LSP server info" })

	commands_registered = true
end

return M
