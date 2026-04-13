local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("rust_analyzer", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,

		settings = {
			["rust-analyzer"] = {
				cargo = {
					allFeatures = true,
				},
				checkOnSave = {
					command = "clippy",
				},
				diagnostics = {
					disabled = { "unresolved-proc-macro" },
				},
				completion = {
					autoimport = { enable = true },
				},
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},
	})

	vim.lsp.enable("rust_analyzer")
end

function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "<leader>re", function()
		client:request("rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), function(err, result)
			if err then
				vim.notify("expandMacro failed: " .. tostring(err.message), vim.log.levels.ERROR)
				return
			end
			if result and result.expansion then
				vim.lsp.util.open_floating_preview(
					vim.split(result.expansion, "\n"),
					"rust",
					{ border = "rounded", title = "Macro Expansion" }
				)
			end
		end)
	end, vim.tbl_extend("force", opts, { desc = "Expand macro (rust)" }))

	vim.keymap.set("n", "<leader>rc", function()
		client:request("rust-analyzer/openCargoToml", vim.lsp.util.make_position_params(), function(err, result)
			if err or not result then
				return
			end
			vim.cmd("edit " .. vim.uri_to_fname(result.uri))
		end)
	end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
end

return M
