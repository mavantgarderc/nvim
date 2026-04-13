local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	local settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			preferences = {
				includeCompletionsForModuleExports = true,
				includeCompletionsWithInsertText = true,
				quoteStyle = "single",
				importModuleSpecifier = "relative",
			},
			suggest = {
				autoImports = true,
				completeFunctionCalls = true,
				completeJSDocs = true,
			},
			updateImportsOnFileMove = "always",
		},

		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			preferences = {
				includeCompletionsForModuleExports = true,
				includeCompletionsWithInsertText = true,
				quoteStyle = "single",
				importModuleSpecifier = "relative",
			},
			suggest = {
				autoImports = true,
				completeFunctionCalls = true,
				completeJSDocs = true,
			},
			updateImportsOnFileMove = "always",
		},
	}

	vim.lsp.config("ts_ls", {
		capabilities = capabilities,
		settings = settings,

		on_attach = function(client, _)
			client.server_capabilities.documentFormattingProvider = false
		end,
	})

	vim.lsp.enable("ts_ls")
end

return M
