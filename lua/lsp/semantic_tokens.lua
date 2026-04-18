-- semantic_tokens.lua

local M = {}

local config = {
	enabled = true,
	filetype_overrides = {},
	disabled_filetypes = {},
	highlight_overrides = {},
}

local state = {
	enabled_bufs = {},
	client_tokens = {},
}

local commands_registered = false

local function apply_highlight_overrides()
	for token_type, hl in pairs(config.highlight_overrides) do
		local group = "@lsp.type." .. token_type
		if type(hl) == "string" then
			vim.api.nvim_set_hl(0, group, { link = hl })
		elseif type(hl) == "table" then
			vim.api.nvim_set_hl(0, group, hl)
		end
	end
end

local function is_filetype_disabled(ft)
	return vim.tbl_contains(config.disabled_filetypes, ft)
end

function M.enable(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_valid(bufnr) or not config.enabled then
		return false
	end

	local ft = vim.bo[bufnr].filetype
	if is_filetype_disabled(ft) then
		return false
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local started = false

	for _, client in ipairs(clients) do
		if client.supports_method("textDocument/semanticTokens/full") then
			vim.lsp.semantic_tokens.start(bufnr, client.id)

			state.client_tokens[bufnr] = state.client_tokens[bufnr] or {}
			state.client_tokens[bufnr][client.id] = true
			started = true
		end
	end

	if started then
		state.enabled_bufs[bufnr] = true
	end

	return started
end

function M.disable(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, client in ipairs(clients) do
		pcall(vim.lsp.semantic_tokens.stop, bufnr, client.id)
	end

	state.enabled_bufs[bufnr] = nil
	state.client_tokens[bufnr] = nil
end

function M.toggle(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if state.enabled_bufs[bufnr] then
		M.disable(bufnr)
		vim.notify("Semantic tokens: OFF", vim.log.levels.INFO)
	else
		local success = M.enable(bufnr)
		if success then
			vim.notify("Semantic tokens: ON", vim.log.levels.INFO)
		else
			vim.notify("Semantic tokens: not available for this buffer", vim.log.levels.WARN)
		end
	end
end

function M.toggle_global()
	config.enabled = not config.enabled

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			if config.enabled then
				M.enable(buf)
			else
				M.disable(buf)
			end
		end
	end

	vim.notify("Semantic tokens global: " .. (config.enabled and "ON" or "OFF"), vim.log.levels.INFO)
end

function M.status(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype

	local active_clients = {}
	if state.client_tokens[bufnr] then
		for client_id in pairs(state.client_tokens[bufnr]) do
			local client = vim.lsp.get_client_by_id(client_id)
			if client then
				table.insert(active_clients, client.name)
			end
		end
	end

	return {
		global = config.enabled,
		buffer = state.enabled_bufs[bufnr] or false,
		filetype = ft,
		disabled_ft = is_filetype_disabled(ft),
		active_clients = active_clients,
	}
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	apply_highlight_overrides()

	if not commands_registered then
		vim.api.nvim_create_user_command("LspSemanticTokensToggle", function()
			M.toggle()
		end, { desc = "Toggle semantic tokens for the current buffer" })

		vim.api.nvim_create_user_command("LspSemanticTokensGlobal", function()
			M.toggle_global()
		end, { desc = "Toggle semantic tokens globally" })

		vim.api.nvim_create_user_command("LspSemanticTokensStatus", function()
			local status = M.status()
			local clients_str = #status.active_clients > 0 and table.concat(status.active_clients, ", ") or "none"

			vim.notify(
				string.format(
					"Semantic tokens:\n  global=%s\n  buffer=%s\n  filetype=%s\n  disabled_ft=%s\n  clients=%s",
					status.global,
					status.buffer,
					status.filetype,
					status.disabled_ft,
					clients_str
				),
				vim.log.levels.INFO
			)
		end, { desc = "Show semantic token status" })

		commands_registered = true
	end

	if not config.enabled then
		return
	end

	local group = vim.api.nvim_create_augroup("LspSemanticTokens", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client or not client.supports_method("textDocument/semanticTokens/full") then
				return
			end

			local ft = vim.bo[ev.buf].filetype
			if is_filetype_disabled(ft) then
				return
			end

			-- Apply filetype-specific overrides
			local ft_overrides = config.filetype_overrides[ft]
			if ft_overrides then
				for token_type, hl in pairs(ft_overrides) do
					local hl_group = "@lsp.type." .. token_type .. "." .. ft
					if type(hl) == "string" then
						vim.api.nvim_set_hl(0, hl_group, { link = hl })
					elseif type(hl) == "table" then
						vim.api.nvim_set_hl(0, hl_group, hl)
					end
				end
			end

			M.enable(ev.buf)
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		callback = function(ev)
			if not state.client_tokens[ev.buf] then
				return
			end

			state.client_tokens[ev.buf][ev.data.client_id] = nil

			-- If no more clients providing tokens, disable
			if vim.tbl_isempty(state.client_tokens[ev.buf]) then
				state.enabled_bufs[ev.buf] = nil
				state.client_tokens[ev.buf] = nil
			end
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(ev)
			state.enabled_bufs[ev.buf] = nil
			state.client_tokens[ev.buf] = nil
		end,
	})
end

return M
