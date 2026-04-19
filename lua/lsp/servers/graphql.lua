local M = {}

function M.setup(capabilities)
	vim.lsp.config("graphql", {
		capabilities = capabilities,

		filetypes = {
			"graphql",
			"typescriptreact",
			"javascriptreact",
		},

		settings = {
			graphql = {
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("graphql")
end

return M
