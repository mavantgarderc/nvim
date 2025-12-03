local M = {}

function M.setup(capabilities)
	local go_ok, lspconfig = pcall(require, "lspconfig")
	if not go_ok or not lspconfig then
		vim.notify("[lsp.servers.go] lspconfig not found", vim.log.levels.WARN)
		return
	end

	local go_server = lspconfig.gopls
	if not go_server then
		vim.notify("[lsp.servers.go] gopls not registered in lspconfig", vim.log.levels.WARN)
		return
	end

	go_server.setup({
		capabilities = capabilities,
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					nilness = true,
					shadow = true,
				},
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
				staticcheck = true,
				gofumpt = false,
			},
		},
	})
end

return M
