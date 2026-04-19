local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("zls", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			zls = {
				enable_snippets = true,
				enable_autofix = true,
				warn_style = true,
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("zls")
end

return M
