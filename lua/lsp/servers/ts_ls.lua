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

	local function code_action(kind, desc)
		return function()
			vim.lsp.buf.code_action({
				apply = true,
				context = { only = { kind }, diagnostics = {} },
			})
		end,
			desc
	end

	vim.keymap.set("n", "<leader>to", code_action("source.organizeImports.ts", "Organize imports (TS)"))
	vim.keymap.set("n", "<leader>ta", code_action("source.addMissingImports.ts", "Add missing imports (TS)"))
	vim.keymap.set("n", "<leader>tu", code_action("source.removeUnused.ts", "Remove unused (TS)"))

	-- remap all three with buffer scope
	for _, map in ipairs({
		{ "<leader>to", "source.organizeImports.ts", "Organize imports (TS)" },
		{ "<leader>ta", "source.addMissingImports.ts", "Add missing imports (TS)" },
		{ "<leader>tu", "source.removeUnused.ts", "Remove unused (TS)" },
	}) do
		vim.keymap.set("n", map[1], function()
			vim.lsp.buf.code_action({
				apply = true,
				context = { only = { map[2] }, diagnostics = {} },
			})
		end, vim.tbl_extend("force", opts, { desc = map[3] }))
	end
end

return M
