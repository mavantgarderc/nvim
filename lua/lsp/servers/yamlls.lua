local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("yamlls", {
		capabilities = capabilities,

		settings = {
			yaml = {
				keyOrdering = false,
				format = {
					enable = true,
				},
				validate = true,
				hover = true,
				completion = true,
				trace = {
					server = "off",
				},
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					["https://json.schemastore.org/github-action.json"] = "/.github/actions/*",
				},
				customTags = {
					"!Ref scalar",
					"!Ref mapping",
					"!Sub scalar",
					"!Sub mapping",
					"!GetAtt scalar",
					"!GetAtt mapping",
					"!FindInMap scalar",
					"!FindInMap mapping",
					"!ImportValue scalar",
					"!ImportValue mapping",
					"!Join scalar",
					"!Join mapping",
					"!Select scalar",
					"!Select mapping",
				},
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("yamlls")
end

return M
