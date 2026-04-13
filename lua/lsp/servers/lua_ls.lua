local M = {}

function M.setup(capabilities)
	-- Skip if no UI (headless)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("lua_ls", {
		capabilities = capabilities,

		on_attach = function(client)
			-- Disable formatting (you use stylua etc)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },

				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
					checkThirdParty = false,
				},

				telemetry = { enable = false },

				completion = {
					callSnippet = "Replace",
				},

				format = {
					enable = false,
				},

				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("lua_ls")
end

return M
