if #vim.api.nvim_list_uis() == 0 then
	return { setup = function() end }
end

local M = {}

function M.setup(capabilities)
	vim.defer_fn(function()
		local ts_ls_ok, lspconfig = pcall(require, "lspconfig")
		if not ts_ls_ok then
			vim.notify("[lsp.servers.typescript] nvim-lspconfig not found", vim.log.levels.WARN)
			return
		end

		local ts_ls_config_ok = pcall(require, "lspconfig.server_configurations.ts_ls")
		if not ts_ls_config_ok then
			vim.notify("[lsp.servers.typescript] ts_ls configuration not available", vim.log.levels.WARN)
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
			},
		}

		local solidity_server_setup_ok, err = pcall(function()
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				settings = settings,
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			})
		end)

		if not solidity_server_setup_ok then
			vim.notify("[lsp.servers.typescript] Setup failed: " .. tostring(err), vim.log.levels.WARN)
		end
	end, 100)
end

return M
