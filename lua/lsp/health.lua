local M = {}

local dynamic = require("lsp.dynamic")

M.errors = {}
M.latency = {}
M.start_times = {}

local dashboard_buf = nil
local dashboard_win = nil
local refresh_timer = nil
local server_lines = {}
local hl_ns = vim.api.nvim_create_namespace("lsp_health")

-- Error capture
local orig_err_handler = vim.lsp.handlers["window/showMessage"]
vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config)
	if result and result.type == 1 then
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local name = client and client.name or ("id:" .. ctx.client_id)
		M.errors[name] = M.errors[name] or {}
		table.insert(M.errors[name], {
			msg = result.message,
			time = os.time(),
		})
		if #M.errors[name] > 20 then
			table.remove(M.errors[name], 1)
		end
		-- auto-refresh dashboard if open
		M.refresh()
	end
	if orig_err_handler then
		orig_err_handler(err, result, ctx, config)
	end
end

-- Latency probe
function M.probe_latency(client)
	if not client or not client.supports_method("textDocument/hover") then
		return
	end

	-- find a valid attached buffer for this client
	local bufnr = nil
	for b in pairs(client.attached_buffers or {}) do
		if vim.api.nvim_buf_is_valid(b) then
			bufnr = b
			break
		end
	end
	if not bufnr then
		return
	end

	local params = {
		textDocument = vim.lsp.util.make_text_document_params(bufnr),
		position = { line = 0, character = 0 },
	}
	local start = vim.uv.hrtime()

	client:request("textDocument/hover", params, function(e, _)
		if e then
			return
		end
		local elapsed_ms = (vim.uv.hrtime() - start) / 1e6
		local entry = M.latency[client.name] or { last_ms = 0, avg_ms = 0, samples = 0 }
		entry.samples = entry.samples + 1
		entry.last_ms = elapsed_ms
		entry.avg_ms = entry.avg_ms + (elapsed_ms - entry.avg_ms) / entry.samples
		M.latency[client.name] = entry
		M.refresh()
	end, bufnr)
end

-- Helpers
local function fmt_time(epoch)
	if not epoch then
		return "—"
	end
	local diff = os.time() - epoch
	if diff < 60 then
		return diff .. "s ago"
	end
	if diff < 3600 then
		return math.floor(diff / 60) .. "m ago"
	end
	return math.floor(diff / 3600) .. "h ago"
end

local function fmt_ms(ms)
	if not ms or ms == 0 then
		return "—"
	end
	if ms < 10 then
		return string.format("%.1fms", ms)
	end
	return string.format("%.0fms", ms)
end

local function fmt_uptime(epoch)
	if not epoch then
		return "—"
	end
	local diff = os.time() - epoch
	if diff < 60 then
		return diff .. "s"
	end
	if diff < 3600 then
		return math.floor(diff / 60) .. "m " .. (diff % 60) .. "s"
	end
	local h = math.floor(diff / 3600)
	local m = math.floor((diff % 3600) / 60)
	return h .. "h " .. m .. "m"
end

local function get_server_status(name)
	local clients = vim.lsp.get_clients({ name = name })
	if #clients > 0 then
		local c = clients[1]
		-- check if the process is actually alive
		if c.is_stopped and c:is_stopped() then
			return "error", c
		end
		local errs = M.errors[name]
		if errs and #errs > 0 and (os.time() - errs[#errs].time) < 60 then
			return "error", c
		end
		return "running", c
	end

	local active = dynamic.active[name]
	if active then
		return "idle", nil
	end

	return "stopped", nil
end

local function status_icon(status)
	local icons = {
		running = "● ",
		idle = "◌ ",
		error = "✖ ",
		stopped = "○ ",
	}
	return icons[status] or "? "
end

local function is_open()
	return dashboard_win
		and vim.api.nvim_win_is_valid(dashboard_win)
		and dashboard_buf
		and vim.api.nvim_buf_is_valid(dashboard_buf)
end

-- Render
function M.render()
	local lines = {}
	local hl = {}
	server_lines = {}

	local col_w = 82
	local sep = "─"

	local function pad(s, w)
		local slen = vim.fn.strdisplaywidth(s)
		if slen >= w then
			return s:sub(1, w)
		end
		return s .. string.rep(" ", w - slen)
	end

	local function center(s, w)
		local slen = vim.fn.strdisplaywidth(s)
		local left = math.floor((w - slen) / 2)
		return string.rep(" ", left) .. s
	end

	local function add(line, highlights_list)
		table.insert(lines, line)
		if highlights_list then
			for _, h in ipairs(highlights_list) do
				h[1] = #lines - 1
				table.insert(hl, h)
			end
		end
	end

	-- title
	add("")
	add(
		center("  LSP Health Dashboard", col_w),
		{ { nil, math.floor((col_w - 22) / 2), math.floor((col_w - 22) / 2) + 24, "Title" } }
	)
	add("")

	-- summary bar
	local running_count = #vim.lsp.get_clients()
	local reg_count = vim.tbl_count(dynamic.registry)
	local err_count = 0
	for _, errs in pairs(M.errors) do
		for _, e in ipairs(errs) do
			if (os.time() - e.time) < 300 then
				err_count = err_count + 1
			end
		end
	end

	local summary = string.format(
		"  Servers: %d/%d running    Errors (5m): %d    Workspace: %s",
		running_count,
		reg_count,
		err_count,
		dynamic.workspace_cache
				and next(dynamic.workspace_cache)
				and (function()
					for _, v in pairs(dynamic.workspace_cache) do
						return table.concat(v.profiles or {}, ", ")
					end
					return "—"
				end)()
			or "—"
	)
	add(summary, { { nil, 0, #summary, "Comment" } })
	add("")
	add("  " .. string.rep(sep, col_w - 4), { { nil, 0, col_w, "FloatBorder" } })

	-- collect servers
	local servers = {}
	for name in pairs(dynamic.registry) do
		servers[name] = true
	end
	for _, c in ipairs(vim.lsp.get_clients()) do
		servers[c.name] = true
	end

	local sorted = vim.tbl_keys(servers)
	table.sort(sorted)

	-- group by status
	local groups = { running = {}, error = {}, idle = {}, stopped = {} }
	for _, name in ipairs(sorted) do
		local st = get_server_status(name)
		table.insert(groups[st], name)
	end

	local order = {
		{ key = "running", label = "  Running", hl_group = "DiagnosticOk" },
		{ key = "error", label = "  Errors", hl_group = "DiagnosticError" },
		{ key = "idle", label = "  Idle", hl_group = "DiagnosticInfo" },
		{ key = "stopped", label = "  Stopped", hl_group = "Comment" },
	}

	-- column spec
	local C = {
		{ name = "Server", w = 18 },
		{ name = "Status", w = 10 },
		{ name = "Latency", w = 16 },
		{ name = "Uptime", w = 10 },
		{ name = "Last Used", w = 10 },
		{ name = "Reap In", w = 9 },
		{ name = "Bufs", w = 5 },
	}

	-- header row
	add("")
	local hdr = "  "
	for _, c in ipairs(C) do
		hdr = hdr .. pad(c.name, c.w)
	end
	add(hdr, { { nil, 0, #hdr, "@markup.heading" } })
	add("  " .. string.rep(sep, col_w - 4), { { nil, 0, col_w, "FloatBorder" } })

	local any_server = false

	for _, g in ipairs(order) do
		local members = groups[g.key]
		if #members > 0 then
			any_server = true
			add("")
			add(g.label, { { nil, 2, 2 + #g.label, g.hl_group } })

			for _, name in ipairs(members) do
				local status, client = get_server_status(name)
				local active = dynamic.active[name]
				local reg = dynamic.registry[name]
				local lat = M.latency[name]

				-- latency
				local lat_str = "—"
				local lat_hl = "Comment"
				if lat then
					lat_str = fmt_ms(lat.last_ms) .. " / " .. fmt_ms(lat.avg_ms)
					if lat.avg_ms < 50 then
						lat_hl = "DiagnosticOk"
					elseif lat.avg_ms < 200 then
						lat_hl = "DiagnosticWarn"
					else
						lat_hl = "DiagnosticError"
					end
				end

				-- uptime
				local uptime_str = fmt_uptime(M.start_times[name])

				-- last used
				local used_str = "—"
				if active and active.last_used then
					used_str = fmt_time(active.last_used)
				end

				-- reap countdown
				local reap_str = "—"
				local reap_hl = "Comment"
				if active and active.last_used and reg and reg.timeout then
					local remaining = reg.timeout - (os.time() - active.last_used)
					if remaining > 60 then
						reap_str = math.floor(remaining / 60) .. "m"
					elseif remaining > 0 then
						reap_str = remaining .. "s"
						reap_hl = "DiagnosticWarn"
					else
						reap_str = "overdue"
						reap_hl = "DiagnosticError"
					end
				end

				-- buf count
				local buf_count = 0
				if client then
					buf_count = vim.tbl_count(client.attached_buffers or {})
				end

				local icon = status_icon(status)
				local row = "  "
					.. icon
					.. pad(name, C[1].w - 2)
					.. pad(status, C[2].w)
					.. pad(lat_str, C[3].w)
					.. pad(uptime_str, C[4].w)
					.. pad(used_str, C[5].w)
					.. pad(reap_str, C[6].w)
					.. tostring(buf_count)

				table.insert(lines, row)
				local ln = #lines

				server_lines[ln] = name

				-- highlight icon + name
				local name_hl = ({
					running = "DiagnosticOk",
					error = "DiagnosticError",
					idle = "DiagnosticInfo",
					stopped = "Comment",
				})[status]
				table.insert(hl, { ln - 1, 2, 2 + 2 + #name, name_hl })

				-- highlight latency cell
				local lat_offset = 2 + C[1].w + C[2].w
				table.insert(hl, { ln - 1, lat_offset, lat_offset + #lat_str, lat_hl })

				-- highlight uptime cell
				local uptime_offset = lat_offset + C[3].w
				if M.start_times[name] then
					table.insert(hl, { ln - 1, uptime_offset, uptime_offset + #uptime_str, "Number" })
				end

				-- highlight reap cell
				local reap_offset = uptime_offset + C[4].w + C[5].w
				table.insert(hl, { ln - 1, reap_offset, reap_offset + #reap_str, reap_hl })
			end
		end
	end

	if not any_server then
		add("")
		add("    No servers registered.", { { nil, 4, 28, "Comment" } })
	end

	-- errors section
	add("")
	add("  " .. string.rep(sep, col_w - 4), { { nil, 0, col_w, "FloatBorder" } })
	add("")

	local err_label = "   Recent Errors"
	add(err_label, { { nil, 3, #err_label, "DiagnosticError" } })

	local has_errors = false
	for name, errs in pairs(M.errors) do
		if #errs > 0 then
			has_errors = true
			add("")
			add("   " .. name, { { nil, 3, 3 + #name, "DiagnosticWarn" } })
			local start_idx = math.max(1, #errs - 2)
			for i = start_idx, #errs do
				local e = errs[i]
				local msg = e.msg:gsub("\n", " "):gsub("%s+", " ")
				if #msg > 55 then
					msg = msg:sub(1, 52) .. "..."
				end
				local ts = fmt_time(e.time)
				add("     " .. ts .. "  " .. msg, { { nil, 5, 5 + #ts, "Number" } })
			end
		end
	end
	if not has_errors then
		add("")
		add("     No errors recorded.", { { nil, 5, 27, "Comment" } })
	end

	-- footer
	add("")
	add("  " .. string.rep(sep, col_w - 4), { { nil, 0, col_w, "FloatBorder" } })

	local keys = {
		{ "t", "start" },
		{ "r", "restart" },
		{ "s", "stop" },
		{ "R", "restart-all" },
		{ "S", "stop-all" },
		{ "p", "probe" },
		{ "P", "probe-all" },
		{ "q", "close" },
	}
	local footer = "  "
	local footer_hls = {}
	for i, k in ipairs(keys) do
		local offset = vim.fn.strdisplaywidth(footer)
		footer = footer .. k[1]
		table.insert(footer_hls, { nil, offset, offset + 1, "Special" })
		footer = footer .. " " .. k[2]
		if i < #keys then
			local sep_offset = vim.fn.strdisplaywidth(footer)
			footer = footer .. "  │  "
			table.insert(footer_hls, { nil, sep_offset + 2, sep_offset + 5, "FloatBorder" })
		end
	end
	table.insert(lines, footer)
	for _, h in ipairs(footer_hls) do
		h[1] = #lines - 1
		table.insert(hl, h)
	end

	add("")

	return lines, hl
end

-- Float window
function M.open()
	if is_open() then
		M.close()
		return -- toggle behavior
	end

	local lines, highlights = M.render()

	dashboard_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(dashboard_buf, 0, -1, false, lines)
	vim.bo[dashboard_buf].modifiable = false
	vim.bo[dashboard_buf].bufhidden = "wipe"
	vim.bo[dashboard_buf].buftype = "nofile"
	vim.bo[dashboard_buf].filetype = "lsp_health"

	-- apply highlights
	for _, h in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(dashboard_buf, hl_ns, h[4], h[1], h[2], h[3])
	end

	local width = 82
	local height = math.min(#lines, math.floor(vim.o.lines * 0.75))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	dashboard_win = vim.api.nvim_open_win(dashboard_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " 󰒋 LSP Health ",
		title_pos = "center",
		footer = " " .. os.date("%H:%M:%S") .. " ",
		footer_pos = "right",
	})

	vim.wo[dashboard_win].cursorline = true
	vim.wo[dashboard_win].winblend = 5

	-- keymaps
	local opts = { buffer = dashboard_buf, silent = true, nowait = true }
	vim.keymap.set("n", "q", M.close, opts)
	vim.keymap.set("n", "<Esc>", M.close, opts)
	vim.keymap.set("n", "r", M.action_restart_cursor, opts)
	vim.keymap.set("n", "t", M.action_start_cursor, opts)
	vim.keymap.set("n", "s", M.action_stop_cursor, opts)
	vim.keymap.set("n", "R", M.action_restart_all, opts)
	vim.keymap.set("n", "S", M.action_stop_all, opts)
	vim.keymap.set("n", "p", M.action_probe_cursor, opts)
	vim.keymap.set("n", "P", M.action_probe_all, opts)

	-- auto-close when leaving the float
	vim.api.nvim_create_autocmd("WinLeave", {
		buffer = dashboard_buf,
		once = true,
		callback = function()
			M.close()
		end,
	})

	-- auto-refresh timer (every 2s while open)
	M.start_auto_refresh()
end

function M.close()
	M.stop_auto_refresh()
	if dashboard_win and vim.api.nvim_win_is_valid(dashboard_win) then
		vim.api.nvim_win_close(dashboard_win, true)
	end
	dashboard_win = nil
	dashboard_buf = nil
end

function M.refresh()
	if not is_open() then
		return
	end

	-- preserve cursor position
	local cursor = vim.api.nvim_win_get_cursor(dashboard_win)

	local lines, highlights = M.render()
	vim.bo[dashboard_buf].modifiable = true
	vim.api.nvim_buf_set_lines(dashboard_buf, 0, -1, false, lines)
	vim.bo[dashboard_buf].modifiable = false
	vim.api.nvim_buf_clear_namespace(dashboard_buf, hl_ns, 0, -1)
	for _, h in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(dashboard_buf, hl_ns, h[4], h[1], h[2], h[3])
	end

	-- update footer timestamp
	if vim.api.nvim_win_is_valid(dashboard_win) then
		vim.api.nvim_win_set_config(dashboard_win, {
			footer = " " .. os.date("%H:%M:%S") .. " ",
			footer_pos = "right",
		})
	end

	-- restore cursor (clamp to new line count)
	local max_line = vim.api.nvim_buf_line_count(dashboard_buf)
	cursor[1] = math.min(cursor[1], max_line)
	pcall(vim.api.nvim_win_set_cursor, dashboard_win, cursor)
end

-- Auto-refresh
function M.start_auto_refresh()
	M.stop_auto_refresh()
	refresh_timer = vim.uv.new_timer()
	refresh_timer:start(
		2000,
		2000,
		vim.schedule_wrap(function()
			if is_open() then
				M.refresh()
			else
				M.stop_auto_refresh()
			end
		end)
	)
end

function M.stop_auto_refresh()
	if refresh_timer then
		refresh_timer:stop()
		refresh_timer:close()
		refresh_timer = nil
	end
end

-- Actions
local function get_server_at_cursor()
	if not is_open() then
		return nil
	end
	local line = vim.api.nvim_win_get_cursor(dashboard_win)[1]
	return server_lines[line]
end

local function notify_action(msg)
	vim.notify(msg, vim.log.levels.INFO, { title = "LSP Health" })
end

function M.action_restart_cursor()
	local name = get_server_at_cursor()
	if not name then
		return vim.notify("No server on this line", vim.log.levels.WARN)
	end

	local clients = vim.lsp.get_clients({ name = name })
	for _, c in ipairs(clients) do
		c:stop()
	end

	vim.defer_fn(function()
		vim.cmd("doautocmd FileType " .. vim.bo.filetype)
		notify_action("Restarted " .. name)
		vim.defer_fn(M.refresh, 500)
	end, 300)
end

function M.action_start_cursor()
	local name = get_server_at_cursor()
	if not name then
		return vim.notify("No server on this line", vim.log.levels.WARN)
	end

	local clients = vim.lsp.get_clients({ name = name })
	if #clients > 0 then
		vim.notify(name .. " is already running", vim.log.levels.WARN)
		return
	end

	if dynamic.try_spawn then
		dynamic.try_spawn(name, vim.api.nvim_get_current_buf())
	else
		local ok_cfg, custom = pcall(require, "lsp.servers." .. name)
		local opts = (ok_cfg and type(custom) == "table") and custom or {}
		opts.capabilities = require("lsp.shared").capabilities
		vim.lsp.config(name, opts)
		vim.lsp.enable(name)
	end

	notify_action("Starting " .. name .. "...")
	vim.defer_fn(M.refresh, 500)
end

function M.action_stop_cursor()
	local name = get_server_at_cursor()
	if not name then
		return vim.notify("No server on this line", vim.log.levels.WARN)
	end

	local clients = vim.lsp.get_clients({ name = name })
	for _, c in ipairs(clients) do
		c:stop()
	end
	dynamic.active[name] = nil
	notify_action("Stopped " .. name)
	vim.defer_fn(M.refresh, 300)
end

function M.action_restart_all()
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
	end
	vim.defer_fn(function()
		vim.cmd("doautocmd FileType " .. vim.bo.filetype)
		notify_action("Restarted all servers")
		vim.defer_fn(M.refresh, 500)
	end, 300)
end

function M.action_stop_all()
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
	end
	dynamic.active = {}
	notify_action("Stopped all servers")
	vim.defer_fn(M.refresh, 300)
end

function M.action_probe_cursor()
	local name = get_server_at_cursor()
	if not name then
		return vim.notify("No server on this line", vim.log.levels.WARN)
	end
	local clients = vim.lsp.get_clients({ name = name })
	if #clients > 0 then
		M.probe_latency(clients[1])
		notify_action("Probing " .. name .. "...")
	else
		vim.notify(name .. " is not running", vim.log.levels.WARN)
	end
end

function M.action_probe_all()
	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		return vim.notify("No running servers", vim.log.levels.WARN)
	end
	for _, client in ipairs(clients) do
		M.probe_latency(client)
	end
	notify_action("Probing " .. #clients .. " servers...")
end

-- Track start times
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_health_attach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and not M.start_times[client.name] then
			M.start_times[client.name] = os.time()
		end
		M.refresh()
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = vim.api.nvim_create_augroup("lsp_health_detach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			M.start_times[client.name] = nil
		end
		M.refresh()
	end,
})

-- Commands & keymap
vim.api.nvim_create_user_command("LspHealth", function()
	M.open()
end, { desc = "Toggle LSP Health Dashboard" })

vim.keymap.set("n", "<leader>lh", function()
	require("lsp.health").open()
end, { desc = "LSP Health Dashboard" })

return M
