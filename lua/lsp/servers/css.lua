local M = {}

function M.setup(capabilities)
	vim.lsp.config("cssls", {
		capabilities = capabilities,
		settings = {
			css = {
				validate = true,
				lint = { unknownAtRules = "ignore" },
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
			scss = {
				validate = true,
				lint = { unknownAtRules = "ignore" },
			},
			less = {
				validate = true,
				lint = { unknownAtRules = "ignore" },
			},
		},
	})

	vim.lsp.enable("cssls")
end

return M
