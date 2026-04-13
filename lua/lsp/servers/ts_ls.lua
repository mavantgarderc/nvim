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

function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Organize imports
	vim.keymap.set("n", "<leader>to", function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
			apply = true,
		})
	end, vim.tbl_extend("force", opts, { desc = "Organize imports (TS)" }))

	-- Add missing imports
	vim.keymap.set("n", "<leader>ta", function()
		vim.lsp.buf.code_action({
			context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
			apply = true,
		})
	end, vim.tbl_extend("force", opts, { desc = "Add missing imports (TS)" }))

	-- Remove unused imports
	vim.keymap.set("n", "<leader>tu", function()
		vim.lsp.buf.code_action({
			context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
			apply = true,
		})
	end, vim.tbl_extend("force", opts, { desc = "Remove unused (TS)" }))
end

return M
