local M = {}

local dynamic = require("lsp.dynamic")

---@class ProgressEntry
---@field token string|number
---@field title string
---@field message string|nil
---@field percentage number|nil
---@field done boolean
---@field client_id number
---@field client_name string
---@field begin_ms number
---@field update_ms number

---@type table<string, ProgressEntry>  -- key = "client_id:token"
local active_tasks = {}

--- spinner frames
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_idx = 0
local timer = nil
local setup_done = false

--- Format a single progress entry into a display string
---@param entry ProgressEntry
---@return string
local function format_entry(entry)
	local parts = { entry.client_name, ":" }

	if entry.title then
		table.insert(parts, " " .. entry.title)
	end
	if entry.message then
		table.insert(parts, " — " .. entry.message)
	end
	if entry.percentage then
		table.insert(parts, string.format(" (%d%%)", entry.percentage))
	end

	return table.concat(parts)
end

--- Build the full status line string from all active tasks
---@return string
function M.status()
	if vim.tbl_isempty(active_tasks) then
		return ""
	end

	spinner_idx = (spinner_idx + 1) % #spinner
	local frame = spinner[spinner_idx + 1]

	local lines = {}
	for _, entry in pairs(active_tasks) do
		if not entry.done then
			table.insert(lines, format_entry(entry))
		end
	end

	if #lines == 0 then
		return ""
	end

	-- compact: show first task + count if multiple
	if #lines == 1 then
		return frame .. " " .. lines[1]
	end
	return string.format("%s %s (+%d more)", frame, lines[1], #lines - 1)
end

--- Check if any server is currently busy
---@return boolean
function M.is_busy()
	for _, entry in pairs(active_tasks) do
		if not entry.done then
			return true
		end
	end
	return false
end

--- Get detailed info about all active tasks
---@return ProgressEntry[]
function M.get_tasks()
	local tasks = {}
	for _, entry in pairs(active_tasks) do
		if not entry.done then
			table.insert(tasks, vim.deepcopy(entry))
		end
	end
	-- sort by begin time
	table.sort(tasks, function(a, b)
		return a.begin_ms < b.begin_ms
	end)
	return tasks
end

--- Get per-server summary: which servers are idle vs working
---@return table<string, { busy: boolean, tasks: number, name: string }>
function M.server_states()
	local states = {}

	-- seed from dynamic.active so we know about all running servers
	for name, info in pairs(dynamic.active or {}) do
		states[name] = { busy = false, tasks = 0, name = name }
	end

	-- overlay with active progress
	for _, entry in pairs(active_tasks) do
		if not entry.done then
			local name = entry.client_name
			if not states[name] then
				states[name] = { busy = false, tasks = 0, name = name }
			end
			states[name].busy = true
			states[name].tasks = states[name].tasks + 1
		end
	end

	return states
end

--- Handle an incoming progress message from LSP
---@param result table  -- the $/progress params
---@param client_id number
local function handle_progress(result, client_id)
	local token = result.token
	if not token then
		return
	end

	local key = string.format("%d:%s", client_id, tostring(token))
	local value = result.value
	if not value then
		return
	end

	local client = vim.lsp.get_client_by_id(client_id)
	local client_name = client and client.name or ("client_" .. client_id)

	local now = vim.uv.hrtime() / 1e6 -- ms

	if value.kind == "begin" then
		active_tasks[key] = {
			token = token,
			title = value.title or "",
			message = value.message,
			percentage = value.percentage,
			done = false,
			client_id = client_id,
			client_name = client_name,
			begin_ms = now,
			update_ms = now,
		}
		start_spinner()
	elseif value.kind == "report" then
		if active_tasks[key] then
			active_tasks[key].message = value.message or active_tasks[key].message
			active_tasks[key].percentage = value.percentage or active_tasks[key].percentage
			active_tasks[key].update_ms = now
		end
	elseif value.kind == "end" then
		if active_tasks[key] then
			active_tasks[key].done = true
			active_tasks[key].message = value.message or "done"
			active_tasks[key].update_ms = now

			-- notify completion for long tasks (>2s)
			local elapsed = now - active_tasks[key].begin_ms
			if elapsed > 2000 then
				vim.schedule(function()
					vim.notify(
						string.format("%s: %s (%.1fs)", client_name, active_tasks[key].title, elapsed / 1000),
						vim.log.levels.INFO
					)
				end)
			end

			-- cleanup after short delay so status line can show "done" briefly
			vim.defer_fn(function()
				active_tasks[key] = nil
				if not M.is_busy() then
					stop_spinner()
				end
			end, 500)
		end
	end
end

--- Start the spinner timer for statusline refresh
function start_spinner()
	if timer then
		return
	end
	timer = vim.uv.new_timer()
	timer:start(
		0,
		80,
		vim.schedule_wrap(function()
			if not M.is_busy() then
				stop_spinner()
				return
			end
			-- trigger statusline redraw
			vim.cmd("redrawstatus")
		end)
	)
end

--- Stop the spinner timer
function stop_spinner()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
	-- one final redraw to clear spinner
	vim.schedule(function()
		vim.cmd("redrawstatus")
	end)
end

--- :LspProgress — display all active tasks in a floating window
function M.show()
	local tasks = M.get_tasks()
	local states = M.server_states()

	local lines = {}
	table.insert(lines, "LSP Progress")
	table.insert(lines, string.rep("─", 50))

	-- server overview
	local server_names = vim.tbl_keys(states)
	table.sort(server_names)
	for _, name in ipairs(server_names) do
		local s = states[name]
		local icon = s.busy and "●" or "○"
		local status = s.busy and string.format("working (%d task%s)", s.tasks, s.tasks > 1 and "s" or "") or "idle"
		table.insert(lines, string.format("  %s %s — %s", icon, name, status))
	end

	if #tasks > 0 then
		table.insert(lines, "")
		table.insert(lines, "Active Tasks:")
		table.insert(lines, string.rep("─", 50))
		for _, t in ipairs(tasks) do
			local elapsed = (vim.uv.hrtime() / 1e6 - t.begin_ms) / 1000
			local pct = t.percentage and string.format(" %d%%", t.percentage) or ""
			table.insert(
				lines,
				string.format("  [%s] %s%s (%.1fs)", t.client_name, t.title, pct, elapsed)
			)
			if t.message then
				table.insert(lines, "         " .. t.message)
			end
		end
	elseif vim.tbl_isempty(states) then
		table.insert(lines, "")
		table.insert(lines, "  No LSP servers active")
	else
		table.insert(lines, "")
		table.insert(lines, "  All servers idle")
	end

	-- render in floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "lsp_progress"

	local width = 54
	local height = math.min(#lines, 20)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " LSP Progress ",
		title_pos = "center",
	})

	-- close on q or <Esc>
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, nowait = true })
end

--- Setup handler, commands, and keymaps
function M.setup()
	if setup_done then
		return
	end

	-- Register the $/progress handler
	local orig_handler = vim.lsp.handlers["$/progress"]
	vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
		-- call original if exists (e.g., fidget.nvim)
		if orig_handler then
			orig_handler(err, result, ctx, config)
		end
		handle_progress(result, ctx.client_id)
	end

	-- Commands
	vim.api.nvim_create_user_command("LspProgress", function()
		M.show()
	end, { desc = "Show LSP progress status" })

	vim.api.nvim_create_user_command("LspProgressClear", function()
		active_tasks = {}
		stop_spinner()
		vim.notify("LSP progress cleared", vim.log.levels.INFO)
	end, { desc = "Clear all tracked LSP progress" })

	-- Cleanup on LspDetach
	vim.api.nvim_create_autocmd("LspDetach", {
		group = vim.api.nvim_create_augroup("lsp_progress_cleanup", { clear = true }),
		callback = function(args)
			local client_id = args.data and args.data.client_id
			if client_id then
				-- remove all tasks for this client
				for key, entry in pairs(active_tasks) do
					if entry.client_id == client_id then
						active_tasks[key] = nil
					end
				end
				if not M.is_busy() then
					stop_spinner()
				end
			end
		end,
	})

	setup_done = true
end

return M
