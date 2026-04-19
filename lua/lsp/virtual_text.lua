local M = {}

local config = {
	enabled = true,
	position = "eol", -- "eol" | "inline" | "right_align"
	max_length = 80,
	prefix = "■ ",
	spacing = 4,
	severity_sort = true,
	severity_styles = {
		[vim.diagnostic.severity.ERROR] = { "DiagnosticVirtualTextError" },
		[vim.diagnostic.severity.WARN] = { "DiagnosticVirtualTextWarn" },
		[vim.diagnostic.severity.INFO] = { "DiagnosticVirtualTextInfo" },
		[vim.diagnostic.severity.HINT] = { "DiagnosticVirtualTextHint" },
	},
	filter = nil, -- function(diagnostic) -> bool
}

local commands_registered = false

local function truncate(text, max)
	if not max or max <= 0 then
		return text
	end
	if #text > max then
		return text:sub(1, max - 1) .. "…"
	end
	return text
end

local function format_diagnostic(diagnostic)
	if config.filter and not config.filter(diagnostic) then
		return nil
	end
	local msg = diagnostic.message:gsub("\n", " ")
	msg = truncate(msg, config.max_length)
	local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
	local code = diagnostic.code and (" (" .. tostring(diagnostic.code) .. ")") or ""
	return source .. msg .. code
end

function M.setup(opts)
	opts = opts or {}
	config = vim.tbl_deep_extend("force", config, opts)

	vim.diagnostic.config({
		virtual_text = config.enabled and {
			spacing = config.spacing,
			prefix = config.prefix,
			virt_text_pos = config.position,
			format = function(diagnostic)
				return format_diagnostic(diagnostic)
			end,
		} or false,
		severity_sort = config.severity_sort,
	})

	if commands_registered then
		return
	end

	vim.api.nvim_create_user_command("LspVirtualTextToggle", function()
		M.toggle()
	end, { desc = "Toggle diagnostic virtual text" })

	commands_registered = true
end

function M.toggle()
	config.enabled = not config.enabled
	M.setup(config)
	vim.notify("LSP virtual text: " .. (config.enabled and "ON" or "OFF"), vim.log.levels.INFO)
end

function M.set_severity(min_severity)
	config.filter = function(d)
		return d.severity <= min_severity
	end
	M.setup(config)
end

function M.is_enabled()
	return config.enabled
end

return M
