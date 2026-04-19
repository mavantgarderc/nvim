local M = {}

function M.setup(capabilities)
	vim.lsp.config("jsonls", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("jsonls")
end

return M
