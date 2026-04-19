local M = {}

--- @class DynamicServerConfig
--- @field filetypes string[]
--- @field cmd? string[]
--- @field root_dir? fun(bufnr: integer): string|nil
--- @field settings? table
--- @field on_attach? fun(client: vim.lsp.Client, bufnr: integer)

--- @type table<string, DynamicServerConfig>
M.registry = {}

local required_fields = { "filetypes" }

--- Validate config structure.
--- @param server_name string
--- @param cfg table
--- @return boolean
local function validate(server_name, cfg)
	for _, field in ipairs(required_fields) do
		if cfg[field] == nil then
			vim.notify(
				string.format("[LSP Dynamic] '%s' missing required field '%s'", server_name, field),
				vim.log.levels.ERROR
			)
			return false
		end
	end

	if cfg.filetypes and type(cfg.filetypes) ~= "table" then
		vim.notify(string.format("[LSP Dynamic] '%s' filetypes must be a table", server_name), vim.log.levels.ERROR)
		return false
	end

	if cfg.cmd and type(cfg.cmd) ~= "table" then
		vim.notify(string.format("[LSP Dynamic] '%s' cmd must be a table", server_name), vim.log.levels.ERROR)
		return false
	end

	return true
end

--- Stop active LSP clients for a given server name.
--- @param server_name string
local function stop_clients(server_name)
	local clients = vim.lsp.get_clients({ name = server_name })
	for _, client in ipairs(clients) do
		client:stop(true)
	end
end

--- Apply config and enable the server via built-in API.
--- @param server_name string
--- @param cfg DynamicServerConfig
--- @param capabilities? table
local function activate(server_name, cfg, capabilities)
	local lsp_cfg = vim.tbl_deep_extend("force", cfg, {
		capabilities = capabilities or {},
	})

	-- Remove non-lsp keys before passing to vim.lsp.config
	lsp_cfg.filetypes = lsp_cfg.filetypes or nil

	vim.lsp.config(server_name, lsp_cfg)
	vim.lsp.enable(server_name)
end

--- Register a new dynamic server.
--- @param server_name string
--- @param cfg DynamicServerConfig
--- @param opts? { force?: boolean, capabilities?: table }
function M.register(server_name, cfg, opts)
	opts = opts or {}

	if type(server_name) ~= "string" or server_name == "" then
		vim.notify("[LSP Dynamic] Invalid server name for register()", vim.log.levels.ERROR)
		return false
	end

	if type(cfg) ~= "table" then
		vim.notify(string.format("[LSP Dynamic] Invalid config for server '%s'", server_name), vim.log.levels.ERROR)
		return false
	end

	if not validate(server_name, cfg) then
		return false
	end

	if M.registry[server_name] and not opts.force then
		vim.notify(
			string.format("[LSP Dynamic] '%s' already registered (use force=true to overwrite)", server_name),
			vim.log.levels.WARN
		)
		return false
	end

	M.registry[server_name] = cfg
	activate(server_name, cfg, opts.capabilities)

	return true
end

--- Unregister a server and stop its active clients.
--- @param server_name string
function M.unregister(server_name)
	if not M.registry[server_name] then
		return false
	end

	stop_clients(server_name)
	M.registry[server_name] = nil

	return true
end

--- Get a registered server config.
--- @param server_name string
--- @return DynamicServerConfig|nil
function M.get(server_name)
	return M.registry[server_name]
end

--- Check if a server is registered.
--- @param server_name string
--- @return boolean
function M.is_registered(server_name)
	return M.registry[server_name] ~= nil
end

--- List all registered servers.
--- @return table<string, DynamicServerConfig>
function M.list()
	return vim.deepcopy(M.registry)
end

return M
