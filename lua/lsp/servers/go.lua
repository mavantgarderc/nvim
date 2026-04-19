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

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
			params.context = { only = { "source.organizeImports" } }
			local result = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
			for _, action in pairs(result and result.result or {}) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
				end
			end
		end,
		desc = "gopls: organize imports on save",
	})

	vim.keymap.set("n", "<leader>gt", function()
		local name = vim.fn.expand("%:p")
		vim.cmd("split | terminal go test -v -run . " .. vim.fn.shellescape(vim.fn.fnamemodify(name, ":h")))
	end, vim.tbl_extend("force", opts, { desc = "Run go test (package)" }))

	vim.keymap.set("n", "<leader>gi", function()
		vim.lsp.buf.code_action({
			apply = true,
			context = { only = { "source.organizeImports" }, diagnostics = {} },
		})
	end, vim.tbl_extend("force", opts, { desc = "Organize imports (Go)" }))
end

return M
