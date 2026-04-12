local M = {}

local mason_registry = require("mason-registry")

local filetype_to_server = {
	python = "pyright",
	javascript = "tsserver",
	typescript = "tsserver",
	html = "html",
	css = "cssls",
	json = "jsonls",
	yaml = "yamlls",
	dockerfile = "dockerls",
	sh = "bashls",
	terraform = "terraformls",
}

local server_to_mason = {
	pyright = "pyright",
	tsserver = "typescript-language-server",
	html = "html-lsp",
	cssls = "css-lsp",
	jsonls = "json-lsp",
	yamlls = "yaml-language-server",
	dockerls = "dockerfile-language-server",
	bashls = "bash-language-server",
	terraformls = "terraform-ls",
}

local function ensure_installed(server)
	local pkg_name = server_to_mason[server]
	if not pkg_name then
		vim.notify("No Mason package for server: " .. server, vim.log.levels.WARN)
		return
	end

	if mason_registry.is_installed(pkg_name) then
		return
	end

	local ok, pkg = pcall(mason_registry.get_package, pkg_name)
	if not ok then
		vim.notify("Mason package missing: " .. pkg_name, vim.log.levels.ERROR)
		return
	end

	vim.notify("Installing LSP: " .. pkg_name)
	pkg:install()
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(event)
		local server = filetype_to_server[event.match]
		if server then
			ensure_installed(server)
		end
	end,
})

return M
