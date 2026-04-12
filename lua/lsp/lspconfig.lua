local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local capabilities = require("lsp.shared").capabilities

mason.setup()

local servers = {
	"lua_ls",
	"pyright",
	"tailwindcss",
	"eslint",
	"ts_ls",
	"vimls",
	"html",
	"cssls",
	"jsonls",
	"dockerls",
	"bashls",
	"yamlls",
	"terraformls",
}

mason_lspconfig.setup({
	ensure_installed = servers,
})

for _, server in ipairs(servers) do
	local opts = {}

	local ok, custom = pcall(require, "lsp.servers." .. server)
	if ok and type(custom) == "table" then
		opts = custom
	end

	opts.capabilities = capabilities

	-- STABLE, SUPPORTED, COMPATIBLE WITH YOUR OFFLINE ECOSYSTEM
	vim.lsp.config(server, opts)
	vim.lsp.enable(server)
end
