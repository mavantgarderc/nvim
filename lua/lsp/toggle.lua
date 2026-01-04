local M = {}

local lsp_enabled = true
local buffer_lsp_states = {}

function M.disable_lsp()
	if not lsp_enabled then
		vim.notify("LSP is already disabled", vim.log.levels.WARN)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if not buffer_lsp_states[bufnr] then
		buffer_lsp_states[bufnr] = {}
	end

	for _, client in ipairs(clients) do
		table.insert(buffer_lsp_states[bufnr], {
			id = client.id,
			name = client.name,
		})

		pcall(client.rpc.notify, client, "textDocument/didClose", {
			textDocument = { uri = vim.uri_from_bufnr(bufnr) },
		})

		vim.lsp.buf_detach_client(bufnr, client.id)
	end

	vim.diagnostic.disable(bufnr)

	lsp_enabled = false
	vim.notify("LSP disabled", vim.log.levels.INFO)
end

-- Function to enable all LSP clients for current buffer
function M.enable_lsp()
	if lsp_enabled then
		vim.notify("LSP is already enabled", vim.log.levels.WARN)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()

	vim.diagnostic.enable(bufnr)

	local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

	local filename = vim.api.nvim_buf_get_name(bufnr)

	local group = vim.api.nvim_create_augroup("LspToggleReattach", { clear = false })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		buffer = bufnr,
		callback = function()
			vim.api.nvim_clear_autocmds({
				group = group,
				buffer = bufnr,
			})

			vim.defer_fn(function()
				vim.cmd("edit!")
			end, 10)
		end,
		once = true,
	})

	lsp_enabled = true
	vim.notify("LSP enabled (re-attaching...)", vim.log.levels.INFO)
end

-- Toggle function that switches between enabled/disabled states
function M.toggle_lsp()
	if lsp_enabled then
		M.disable_lsp()
	else
		M.enable_lsp()
	end
end

-- Check if LSP is currently enabled
function M.is_lsp_enabled()
	return lsp_enabled
end

-- Get LSP status
function M.get_lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	local status = {
		enabled = lsp_enabled,
		client_count = #clients,
		clients = {},
	}

	for _, client in ipairs(clients) do
		table.insert(status.clients, {
			id = client.id,
			name = client.name,
			attached = client.attached_buffers[vim.api.nvim_get_current_buf()] ~= nil,
		})
	end

	return status
end

-- Global toggle function to work across all buffers
function M.toggle_lsp_globally()
	local buffers = vim.api.nvim_list_bufs()

	if lsp_enabled then
		for _, bufnr in ipairs(buffers) do
			if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #clients > 0 then
					for _, client in ipairs(clients) do
						pcall(client.rpc.notify, client, "textDocument/didClose", {
							textDocument = { uri = vim.uri_from_bufnr(bufnr) },
						})
						vim.lsp.buf_detach_client(bufnr, client.id)
					end
					vim.diagnostic.disable(bufnr)
				end
			end
		end
		lsp_enabled = false
		vim.notify("LSP globally disabled", vim.log.levels.INFO)
	else
		for _, bufnr in ipairs(buffers) do
			if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("edit!")
				end)
			end
		end
		lsp_enabled = true
		vim.notify("LSP globally enabled (re-attaching...)", vim.log.levels.INFO)
	end
end

return M
