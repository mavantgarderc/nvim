local M = {}

function M.setup(capabilities)
	-- no UI → headless mode
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("pyright", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
		end,

		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
					inlayHints = {
						chainingHints = true,
						parameterHints = true,
					},
				},
			},
		},
	})

	vim.lsp.enable("pyright")
end

return M
