local M = {}

local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
local dynamic = require("lsp.dynamic")

-- filetype -> server_name (vim.lsp.config name)
local filetype_to_server_map = {
	python = "pyright",
	javascript = "ts_ls",
	javascriptreact = "ts_ls",
	typescript = "ts_ls",
	typescriptreact = "ts_ls",
	html = "html",
	templ = "html",
	css = "cssls",
	scss = "cssls",
	less = "cssls",
	json = "jsonls",
	yaml = "yamlls",
	yml = "yamlls",
	dockerfile = "dockerls",
	sh = "bashls",
	terraform = "terraformls",
	lua = "lua_ls",
	rust = "rust_analyzer",
	go = "gopls",
}

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
}

local function ensure_installed(server_name)
	if not mason_registry_ok then
		return
	end

	local pkg_name = server_to_mason_map[server_name]
	if not pkg_name then
		vim.notify(
			string.format("[LSP Dynamic] No Mason package mapping for server '%s'", server_name),
			vim.log.levels.DEBUG
		)
		return
	end

	if mason_registry.is_installed(pkg_name) then
		return
	end

	local ok, pkg = pcall(mason_registry.get_package, pkg_name)
	if not ok or not pkg then
		vim.notify(
			string.format("[LSP Dynamic] Mason package '%s' not found for server '%s'", pkg_name, server_name),
			vim.log.levels.WARN
		)
		return
	end

	vim.notify(string.format("[LSP Dynamic] Installing LSP %s (Mason: %s)", server_name, pkg_name), vim.log.levels.INFO)
	pkg:install()
end

-- Register dynamic servers and (optionally) ensure they’re installed.
function M.register_dynamic_servers(opts)
	opts = opts or {}
	local install = opts.install ~= false

	-- Ensure all registry servers are considered for Mason.
	for server_name, cfg in pairs(dynamic.registry) do
		if install then
			ensure_installed(server_name)
		end
		-- cfg is already in dynamic.registry; dynamic.register lets you override/extend.
		dynamic.register(server_name, cfg)
	end

	-- Also ensure any filetype -> server mapping is consistent with registry.
	for ft, server_name in pairs(filetype_to_server_map) do
		local reg = dynamic.registry[server_name]
		if not reg then
			vim.notify(
				string.format(
					"[LSP Dynamic] Filetype '%s' maps to server '%s' which is not in dynamic.registry",
					ft,
					server_name
				),
				vim.log.levels.WARN
			)
		else
			-- Guarantee that mapped ft is present in registry config
			if not vim.tbl_contains(reg.filetypes or {}, ft) then
				reg.filetypes = reg.filetypes or {}
				table.insert(reg.filetypes, ft)
			end
			dynamic.register(server_name, reg)
			if install then
				ensure_installed(server_name)
			end
		end
	end
end

-- Trigger dynamic start for the current buffer’s filetype.
function M.trigger_for_current_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	if not ft or ft == "" then
		return
	end

	for name, cfg in pairs(dynamic.registry) do
		if vim.tbl_contains(cfg.filetypes or {}, ft) then
			dynamic.start_server(name, bufnr)
		end
	end
end

return M
