local M = {}

local _enabled = {} -- per-buffer toggle state: buf -> bool
local _augroup = nil
local setup_done = false

-- ── Helpers ──────────────────────────────────────────────────────

--- Check if any active LSP client on the buffer supports codeLens
---@param bufnr number
---@return boolean
local function has_codelens_support(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, client in ipairs(clients) do
		if client.server_capabilities.codeLensProvider then
			return true
		end
	end
	return false
end

--- Safely refresh codelens for a buffer
---@param bufnr number
local function refresh(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end
	if not _enabled[bufnr] then
		return
	end
	if not has_codelens_support(bufnr) then
		return
	end

	vim.lsp.codelens.refresh({ bufnr = bufnr })
end

-- ── Per-buffer enable/disable ────────────────────────────────────

---@param bufnr number
local function enable(bufnr)
	_enabled[bufnr] = true
	refresh(bufnr)
end

---@param bufnr number
local function disable(bufnr)
	_enabled[bufnr] = false
	vim.lsp.codelens.clear(nil, bufnr)
end

-- ── Public API ───────────────────────────────────────────────────

--- Toggle codelens for the current or given buffer
---@param bufnr? number
function M.toggle(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if _enabled[bufnr] then
		disable(bufnr)
		vim.notify("[codelens] Disabled for buffer " .. bufnr, vim.log.levels.INFO)
	else
		enable(bufnr)
		vim.notify("[codelens] Enabled for buffer " .. bufnr, vim.log.levels.INFO)
	end
end

--- Run the codelens action at cursor
function M.run()
	vim.lsp.codelens.run()
end

--- Force refresh current buffer
function M.refresh()
	local bufnr = vim.api.nvim_get_current_buf()
	if not has_codelens_support(bufnr) then
		vim.notify("[codelens] No server with codeLens support attached", vim.log.levels.WARN)
		return
	end
	_enabled[bufnr] = true
	refresh(bufnr)
end

--- Show codelens status for all buffers with active LSP
function M.status()
	local lines = { "Code Lens Status:" }
	local bufs = vim.api.nvim_list_bufs()

	local count = 0
	for _, bufnr in ipairs(bufs) do
		if vim.api.nvim_buf_is_loaded(bufnr) and #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name ~= "" then
				local rel = vim.fn.fnamemodify(name, ":~:.")
				local supported = has_codelens_support(bufnr)
				local active = _enabled[bufnr] and true or false

				local state
				if not supported then
					state = "no provider"
				elseif active then
					state = "✓ active"
				else
					state = "✗ disabled"
				end

				table.insert(lines, string.format("  [%d] %-50s %s", bufnr, rel, state))
				count = count + 1
			end
		end
	end

	if count == 0 then
		table.insert(lines, "  No buffers with LSP attached")
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- ── Autocmds ─────────────────────────────────────────────────────

local function setup_autocmds()
	_augroup = vim.api.nvim_create_augroup("lsp_codelens", { clear = true })

	-- auto-enable on LSP attach if server supports it
	vim.api.nvim_create_autocmd("LspAttach", {
		group = _augroup,
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and client.server_capabilities.codeLensProvider then
				-- default to enabled unless user explicitly disabled
				if _enabled[bufnr] == nil then
					_enabled[bufnr] = true
				end
				-- slight delay to let server finish initialization
				vim.defer_fn(function()
					refresh(bufnr)
				end, 300)
			end
		end,
	})

	-- refresh on BufEnter
	vim.api.nvim_create_autocmd("BufEnter", {
		group = _augroup,
		callback = function(args)
			refresh(args.buf)
		end,
	})

	-- refresh after leaving insert mode
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = _augroup,
		callback = function(args)
			-- debounce: small delay so LSP can process changes
			vim.defer_fn(function()
				refresh(args.buf)
			end, 500)
		end,
	})

	-- refresh on text change (normal mode edits, undo, paste)
	vim.api.nvim_create_autocmd("TextChanged", {
		group = _augroup,
		callback = function(args)
			vim.defer_fn(function()
				refresh(args.buf)
			end, 500)
		end,
	})

	-- refresh after save
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = _augroup,
		callback = function(args)
			refresh(args.buf)
		end,
	})

	-- cleanup on detach
	vim.api.nvim_create_autocmd("LspDetach", {
		group = _augroup,
		callback = function(args)
			local bufnr = args.buf
			-- if no remaining clients support codelens, clear
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(bufnr) and not has_codelens_support(bufnr) then
					_enabled[bufnr] = nil
					pcall(vim.lsp.codelens.clear, nil, bufnr)
				end
			end, 100)
		end,
	})

	-- cleanup deleted buffers
	vim.api.nvim_create_autocmd("BufDelete", {
		group = _augroup,
		callback = function(args)
			_enabled[args.buf] = nil
		end,
	})
end

-- ── Setup ────────────────────────────────────────────────────────

function M.setup()
	if setup_done then
		return
	end

	setup_autocmds()

	vim.api.nvim_create_user_command("LensToggle", function()
		M.toggle()
	end, { desc = "Toggle codelens for current buffer" })

	vim.api.nvim_create_user_command("LensRun", function()
		M.run()
	end, { desc = "Run codelens action at cursor" })

	vim.api.nvim_create_user_command("LensRefresh", function()
		M.refresh()
	end, { desc = "Force refresh codelens" })

	vim.api.nvim_create_user_command("LensStatus", function()
		M.status()
	end, { desc = "Show codelens status for all buffers" })

	setup_done = true
end

return M
