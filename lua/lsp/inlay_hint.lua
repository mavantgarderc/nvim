local M = {}

--- @type table<integer, boolean>
M._enabled = {}

M.config = {
	auto_enable = true,
	--- Filetypes to auto-enable inlay hints for (nil = all)
	--- @type string[]|nil
	filetypes = nil,
}

local commands_registered = false

--- Check if inlay hints are supported for buffer
--- @param bufnr integer
--- @return boolean
local function has_inlay_hint_support(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, c in ipairs(clients) do
		if c.supports_method("textDocument/inlayHint") then
			return true
		end
	end
	return false
end

--- Check if filetype is in the allowed list
--- @param bufnr integer
--- @return boolean
local function filetype_allowed(bufnr)
	if not M.config.filetypes then
		return true
	end
	local ft = vim.bo[bufnr].filetype
	return vim.tbl_contains(M.config.filetypes, ft)
end

--- Enable inlay hints for buffer
--- @param bufnr? integer
function M.enable(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not filetype_allowed(bufnr) or not has_inlay_hint_support(bufnr) then
		return
	end
	local ok = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
	if ok then
		M._enabled[bufnr] = true
	end
end

--- Disable inlay hints for buffer
--- @param bufnr? integer
function M.disable(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
	M._enabled[bufnr] = false
end

--- Toggle inlay hints for buffer
--- @param bufnr? integer
function M.toggle(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if M.is_enabled(bufnr) then
		M.disable(bufnr)
	else
		M.enable(bufnr)
	end
end

--- Check if inlay hints are enabled for buffer
--- @param bufnr? integer
--- @return boolean
function M.is_enabled(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ok, enabled = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
	if ok then
		M._enabled[bufnr] = enabled
		return enabled
	end
	return M._enabled[bufnr] == true
end

--- Refresh inlay hints for buffer (re-request from server)
--- @param bufnr? integer
function M.refresh(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not M.is_enabled(bufnr) then
		return
	end

	-- Use native refresh if available (Neovim 0.10+)
	if vim.lsp.inlay_hint.refresh then
		pcall(vim.lsp.inlay_hint.refresh, { bufnr = bufnr })
	else
		-- Fallback: toggle off/on
		pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

--- Get status across all LSP buffers
--- @return table<integer, { enabled: boolean, ft: string, clients: string[] }>
function M.status()
	local result = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			if #clients > 0 then
				local names = {}
				for _, c in ipairs(clients) do
					table.insert(names, c.name)
				end
				result[bufnr] = {
					enabled = M.is_enabled(bufnr), -- Query live state
					ft = vim.bo[bufnr].filetype,
					clients = names,
				}
			end
		end
	end
	return result
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	if not commands_registered then
		vim.api.nvim_create_user_command("InlayToggle", function()
			M.toggle()
			local state = M.is_enabled() and "enabled" or "disabled"
			vim.notify("Inlay hints " .. state, vim.log.levels.INFO)
		end, { desc = "LSP: Toggle inlay hints" })

		vim.api.nvim_create_user_command("InlayRefresh", function()
			M.refresh()
			vim.notify("Inlay hints refreshed", vim.log.levels.INFO)
		end, { desc = "LSP: Refresh inlay hints" })

		vim.api.nvim_create_user_command("InlayStatus", function()
			local st = M.status()
			if vim.tbl_isempty(st) then
				vim.notify("No LSP buffers", vim.log.levels.INFO)
				return
			end
			local lines = {}
			for buf, info in pairs(st) do
				local icon = info.enabled and "✓" or "✗"
				table.insert(
					lines,
					string.format(
						"  %s buf=%d ft=%s clients=[%s]",
						icon,
						buf,
						info.ft,
						table.concat(info.clients, ", ")
					)
				)
			end
			vim.notify("Inlay Hints:\n" .. table.concat(lines, "\n"), vim.log.levels.INFO)
		end, { desc = "LSP: Inlay hints status" })

		commands_registered = true
	end

	local group = vim.api.nvim_create_augroup("LspInlayHints", { clear = true })

	-- Auto-enable on LspAttach
	if M.config.auto_enable then
		vim.api.nvim_create_autocmd("LspAttach", {
			group = group,
			callback = function(ev)
				local bufnr = ev.buf
				-- Schedule to let client finish capability negotiation
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(bufnr) and filetype_allowed(bufnr) then
						M.enable(bufnr)
					end
				end)
			end,
		})
	end

	-- Refresh on BufWritePost
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		callback = function(ev)
			if M.is_enabled(ev.buf) then
				M.refresh(ev.buf)
			end
		end,
	})

	-- Cleanup
	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(ev)
			M._enabled[ev.buf] = nil
		end,
	})
end

return M
