local M = {}

function M.setup(capabilities)
	vim.lsp.config("dockerls", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			docker = {
				languageserver = {
					diagnostics = { enable = true },
				},
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("dockerls")
end

return M
