local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("lua_ls", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						vim.env.VIMRUNTIME,
						"${3rd}/luv/library",
					},
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
				hint = {
					enable = true,
					setType = true,
					paramType = true,
					paramName = "All",
				},
			},
		},
	})

	vim.lsp.enable("lua_ls")
end

-- ── Extender (micro-plugin) ──────────────────────────────────────
-- Runs on every LspAttach for this server, per-buffer
function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Toggle inlay hints
	vim.keymap.set("n", "<leader>le", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints (lua)" }))

	-- Quick access to Lua workspace library reload
	vim.keymap.set("n", "<leader>lw", function()
		client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		vim.notify("lua_ls: workspace config reloaded", vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Reload lua_ls workspace" }))
end

return M
