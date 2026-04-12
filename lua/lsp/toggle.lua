local M = {}
local enabled = true

function M.toggle()
	enabled = not enabled

	if enabled then
		vim.notify("LSP enabled")

		-- Enable all servers declared via vim.lsp.config()
		for name, _ in pairs(vim.lsp._server_configs or {}) do
			vim.lsp.enable(name)
		end

		-- Reattach to current buffer
		vim.lsp.buf_attach_client(0)
	else
		vim.notify("LSP disabled")

		-- Stop all active clients
		for _, client in pairs(vim.lsp.get_active_clients()) do
			vim.lsp.stop_client(client.id, true)
		end
	end
end

return M
