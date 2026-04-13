local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()

local ensure_installed = {
	"lua_ls",
	"pyright",
	"tailwindcss",
	"eslint",
	"ts_ls",
	"vim-language-server",
	"html",
	"cssls",
	"jsonls",
	"dockerls",
	"bashls",
	"yamlls",
	"terraformls",
}

mason_lspconfig.setup({
	ensure_installed = ensure_installed,
})

require("lsp.dynamic")
require("lsp.health")
