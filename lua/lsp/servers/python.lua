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

function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Select virtualenv
	vim.keymap.set("n", "<leader>pe", function()
		local venvs = vim.fn.glob(vim.fn.getcwd() .. "/.venv", true, true)
		local poetry = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock", true, true)
		local hint = (#venvs > 0 and ".venv found") or (#poetry > 0 and "poetry detected") or "no venv detected"
		vim.notify("Python env: " .. hint, vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Python venv info" }))

	-- Organize imports via Pyright
	vim.keymap.set("n", "<leader>pi", function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports" }, diagnostics = {} },
			apply = true,
		})
	end, vim.tbl_extend("force", opts, { desc = "Organize imports (python)" }))
end

return M
