local M = {}

local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
local dynamic = require("lsp.dynamic")
local commands_registered = false

-- server_name -> Mason package name
local server_to_mason_map = {
	pyright = "pyright",
	ts_ls = "typescript-language-server",
	html = "html-lsp",
	cssls = "css-lsp",
	jsonls = "json-lsp",
	yamlls = "yaml-language-server",
	dockerls = "dockerfile-language-server",
	bashls = "bash-language-server",
	terraformls = "terraform-ls",
	lua_ls = "lua-language-server",
	rust_analyzer = "rust-analyzer",
	gopls = "gopls",
	zls = "zls",
	csharp_ls = "csharp_ls",
}

--- Ensure a server's Mason package is installed.
--- @param server_name string
--- @return boolean
local function ensure_installed(server_name)
	if not mason_registry_ok then
		return false
	end

	local pkg_name = server_to_mason_map[server_name]
	if not pkg_name then
		vim.notify(string.format("[LSP Analytics] No Mason mapping for '%s'", server_name), vim.log.levels.DEBUG)
		return false
	end

	local ok, pkg = pcall(mason_registry.get_package, pkg_name)
	if not ok or not pkg then
		vim.notify(string.format("[LSP Analytics] Mason package '%s' not found", pkg_name), vim.log.levels.WARN)
		return false
	end

	if pkg:is_installed() then
		return true
	end

	vim.notify(string.format("[LSP Analytics] Installing %s (mason: %s)", server_name, pkg_name), vim.log.levels.INFO)
	pkg:install()
	return true
end

--- Sync dynamic registry with Mason. Ensures all registered servers are installed.
--- @param opts? { install?: boolean }
function M.register_dynamic_servers(opts)
	opts = opts or {}
	local install = opts.install ~= false

	if not install then
		return
	end

	local seen = {}
	for server_name, _ in pairs(dynamic.list()) do
		if not seen[server_name] then
			seen[server_name] = true
			ensure_installed(server_name)
		end
	end
end

--- Collect status for all registered servers.
--- @return table<string, table>
local function collect_server_status()
	local status = {}

	for server_name, cfg in pairs(dynamic.list()) do
		local mason_pkg = server_to_mason_map[server_name]
		local installed = false

		if mason_registry_ok and mason_pkg then
			local ok, pkg = pcall(mason_registry.get_package, mason_pkg)
			if ok and pkg then
				installed = pkg:is_installed()
			end
		end

		local fts = cfg.filetypes or {}

		status[server_name] = {
			server = server_name,
			filetypes = fts,
			registered = true,
			mason_package = mason_pkg or "N/A",
			installed = installed,
			active_clients = #vim.lsp.get_clients({ name = server_name }),
		}
	end

	return status
end

local function print_status()
	local status = collect_server_status()
	local lines = { "LSP Analytics — Server Status:", "" }

	for name, s in pairs(status) do
		table.insert(
			lines,
			string.format(
				"  %s | ft: %s | mason: %s | installed: %s | clients: %d",
				name,
				table.concat(s.filetypes, ","),
				s.mason_package,
				s.installed and "yes" or "no",
				s.active_clients
			)
		)
	end

	if #lines == 2 then
		table.insert(lines, "  (no servers registered)")
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

local function setup_commands()
	if commands_registered then
		return
	end
	commands_registered = true

	vim.api.nvim_create_user_command("LspDynamicStatus", function()
		print_status()
	end, { desc = "Show LSP dynamic/Mason status" })

	vim.api.nvim_create_user_command("LspDynamicRegister", function(cmd_opts)
		local install = cmd_opts.bang ~= true
		M.register_dynamic_servers({ install = install })
		vim.notify(
			string.format("[LSP Analytics] Registry synced (install=%s)", tostring(install)),
			vim.log.levels.INFO
		)
	end, {
		desc = "Sync dynamic LSP registry with Mason",
		bang = true,
	})
end

function M.setup()
	setup_commands()
end

return M
