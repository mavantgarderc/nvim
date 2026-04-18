local M = {}

local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()

if cmp_ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

capabilities.textDocument.semanticTokens = {
	dynamicRegistration = false,
}

M.capabilities = capabilities

local util_ok, util = pcall(require, "lspconfig.util")
if not util_ok then
	util = require("lspconfig.util.init")
end

function M.find_monorepo_root(fname)
	return util.root_pattern("pnpm-workspace.yaml", "lerna.json", "nx.json", "turbo.json", "package.json", ".git")(
		fname
	)
end

-- UI guard: prevent LSP start in headless/non-interactive environments
function M.should_start_server()
	return #vim.api.nvim_list_uis() > 0
end

-- Shared on_attach: disable formatting by default
function M.on_attach(client, bufnr)
	if client.server_capabilities.documentFormattingProvider then
		client.server_capabilities.documentFormattingProvider = false
	end
	if client.server_capabilities.documentRangeFormattingProvider then
		client.server_capabilities.documentRangeFormattingProvider = false
	end
end

return M
