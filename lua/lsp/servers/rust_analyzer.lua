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
		vim.lsp.buf.code_action({
			apply = true,
			context = { only = { "rust-analyzer.expandMacro" }, diagnostics = {} },
		})
	end, vim.tbl_extend("force", opts, { desc = "Expand macro (Rust)" }))

	vim.keymap.set("n", "<leader>rc", function()
		local root = client.config.root_dir or vim.fn.getcwd()
		local cargo = root .. "/Cargo.toml"
		if vim.fn.filereadable(cargo) == 1 then
			vim.cmd.edit(cargo)
		else
			vim.notify("Cargo.toml not found", vim.log.levels.WARN)
		end
	end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))

	vim.keymap.set("n", "<leader>rr", function()
		client:request("rust-analyzer/reloadWorkspace", nil, function(err)
			if err then
				vim.notify("reload failed: " .. tostring(err), vim.log.levels.ERROR)
			else
				vim.notify("rust-analyzer: workspace reloaded", vim.log.levels.INFO)
			end
		end, bufnr)
	end, vim.tbl_extend("force", opts, { desc = "Reload workspace (Rust)" }))
end

return M
