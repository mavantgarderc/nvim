local M = {}

function M.setup(capabilities)
	vim.lsp.config("gopls", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					nilness = true,
					shadow = true,
				},
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
				staticcheck = true,
				gofumpt = false,
			},
		},
	})

	vim.lsp.enable("gopls")
end

function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Organize imports on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("GoImports_" .. bufnr, { clear = true }),
		buffer = bufnr,
		callback = function()
			local params = vim.lsp.util.make_range_params()
			params.context = { only = { "source.organizeImports" } }
			local result = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
			if result and result.result then
				for _, action in ipairs(result.result) do
					if action.edit then
						vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
					end
				end
			end
		end,
	})

	-- Run go test for current file
	vim.keymap.set("n", "<leader>gt", function()
		local file = vim.fn.expand("%:p:h")
		vim.cmd("split | terminal go test -v " .. file)
	end, vim.tbl_extend("force", opts, { desc = "Go test (current pkg)" }))
end

return M
