local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("yamlls", {
		capabilities = capabilities,

		filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.cloudformation" },

		settings = {
			yaml = {
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
					["https://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
					["https://json.schemastore.org/stylelintrc.json"] = ".stylelintrc.{yml,yaml}",
					["https://json.schemastore.org/circleciconfig.json"] = ".circleci/**/*.{yml,yaml}",
				},

				customTags = {
					"!fn",
					"!And",
					"!If",
					"!Not",
					"!Equals",
					"!Or",
					"!FindInMap sequence",
					"!Base64",
					"!Cidr",
					"!Ref",
					"!Sub",
					"!GetAtt",
					"!GetAZs",
					"!ImportValue",
					"!Select",
					"!Split",
					"!Join sequence",
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
