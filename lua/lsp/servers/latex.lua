local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("texlab", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			texlab = {
				auxDirectory = ".",
				bibtexFormatter = "texlab",
				build = {
					executable = "latexmk",
					args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
					onSave = true,
				},
				forwardSearch = {
					executable = "zathura",
					args = { "%p", "--synctex-forward", "%l:1:%f" },
				},
				chktex = {
					onOpenAndSave = true,
					onEdit = true,
				},
				diagnosticsDelay = 300,
				latexFormatter = "latexindent",
				latexindent = {
					modifyLineBreaks = true,
				},
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("texlab")
end

return M
