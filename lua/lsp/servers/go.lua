local M = {}

function M.setup(capabilities)
	vim.lsp.config("gopls", {
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

	vim.lsp.enable("gopls")
end

return M
