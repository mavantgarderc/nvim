if #vim.api.nvim_list_uis() == 0 then
	return { setup = function() end }
end

local M = {}

function M.setup(capabilities)
	vim.defer_fn(function()
		local ok, lspconfig = pcall(require, "lspconfig")
		if not ok then
			return
		end

		-- Pre-load the server configuration
		local config_ok = pcall(require, "lspconfig.server_configurations.SERVERNAME")
		if not config_ok then
			return
		end

		pcall(function()
			lspconfig.SERVERNAME.setup({
				capabilities = capabilities,
				-- your settings here
			})
		end)
	end, 150) -- Increased delay to ensure lspconfig is ready
end

-- Optional: per-buffer hooks that fire on every LspAttach
-- Signature: extend(client, bufnr)
--
-- function M.extend(client, bufnr)
--   local opts = { buffer = bufnr, silent = true }
--   vim.keymap.set("n", "<leader>xx", function()
--     -- your action
--   end, vim.tbl_extend("force", opts, { desc = "My action" }))
-- end

return M
