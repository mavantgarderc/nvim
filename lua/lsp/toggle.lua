local dynamic = require("lsp.dynamic")

local M = {}
local commands_registered = false

function M.start_server(server_name, bufnr)
	dynamic.try_spawn(server_name, bufnr)
end

function M.stop_server(server_name)
	local clients = vim.lsp.get_clients({ name = server_name })
	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id, true)
	end
	dynamic.active[server_name] = nil
end

-- Toggle a specific named server (e.g. "lua_ls", "pyright").
function M.toggle_server(server_name)
	local clients = vim.lsp.get_clients({ name = server_name })
	if #clients > 0 or dynamic.active[server_name] then
		-- Currently on -> stop
		M.stop_server(server_name)
		vim.notify(string.format("[LSP Dynamic] Disabled %s", server_name), vim.log.levels.INFO)
	else
		-- Currently off -> start (for current buffer)
		M.start_server(server_name, vim.api.nvim_get_current_buf())
		vim.notify(string.format("[LSP Dynamic] Enabled %s", server_name), vim.log.levels.INFO)
	end
end

-- Toggle all dynamic servers relevant to current buffer’s filetype.
function M.toggle_current_filetype()
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	if not ft or ft == "" then
		return
	end

	local to_toggle = {}
	for name, cfg in pairs(dynamic.registry) do
		if vim.tbl_contains(cfg.filetypes or {}, ft) then
			table.insert(to_toggle, name)
		end
	end

	if #to_toggle == 0 then
		vim.notify(string.format("[LSP Dynamic] No registered servers for filetype '%s'", ft), vim.log.levels.WARN)
		return
	end

	-- Determine if we are “mostly on” or “mostly off”.
	local any_on = false
	for _, server_name in ipairs(to_toggle) do
		local clients = vim.lsp.get_clients({ name = server_name, bufnr = bufnr })
		if #clients > 0 then
			any_on = true
			break
		end
	end

	if any_on then
		for _, server_name in ipairs(to_toggle) do
			M.stop_server(server_name)
		end
		vim.notify(string.format("[LSP Dynamic] Disabled LSP(s) for filetype '%s'", ft), vim.log.levels.INFO)
	else
		for _, server_name in ipairs(to_toggle) do
			M.start_server(server_name, bufnr)
		end
		vim.notify(string.format("[LSP Dynamic] Enabled LSP(s) for filetype '%s'", ft), vim.log.levels.INFO)
	end
end

function M.toggle_lsp()
	M.toggle_current_filetype()
end

function M.toggle_lsp_globally()
	local server_names = vim.tbl_keys(dynamic.registry)
	table.sort(server_names)

	local any_on = false
	for _, server_name in ipairs(server_names) do
		if #vim.lsp.get_clients({ name = server_name }) > 0 or dynamic.active[server_name] then
			any_on = true
			break
		end
	end

	if any_on then
		for _, server_name in ipairs(server_names) do
			M.stop_server(server_name)
		end
		vim.notify("[LSP Dynamic] Disabled all dynamic servers", vim.log.levels.INFO)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	for _, server_name in ipairs(server_names) do
		M.start_server(server_name, bufnr)
	end
	vim.notify("[LSP Dynamic] Attempted to enable all dynamic servers", vim.log.levels.INFO)
end

function M.setup()
	if commands_registered then
		return
	end

	vim.api.nvim_create_user_command("LspToggleCurrent", function()
		M.toggle_current_filetype()
	end, { desc = "Toggle dynamic LSP servers for the current filetype" })

	vim.api.nvim_create_user_command("LspToggleGlobal", function()
		M.toggle_lsp_globally()
	end, { desc = "Toggle all dynamic LSP servers" })

	commands_registered = true
end

-- Convenience mappings you can wire from keymaps:
--   require("lsp.toggle").toggle_server("lua_ls")
--   require("lsp.toggle").toggle_current_filetype()

return M
