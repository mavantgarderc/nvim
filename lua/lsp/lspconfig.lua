local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

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

-- Registry of loaded extenders
-- { server_name = extend_fn | nil }
local extenders = {}

-- Unified loader
for _, server in ipairs(servers) do
	local ok, mod = pcall(require, "lsp.servers." .. server)

	if ok and type(mod) == "table" then
		-- Pattern A — module has setup(caps)
		-- (ts_ls, python, go, rust_analyzer, etc.)
		-- ---------------------------------------------
		if type(mod.setup) == "function" then
			mod.setup(capabilities)

			-- Collect extender if the module exports one
			if type(mod.extend) == "function" then
				extenders[server] = mod.extend
			end

		-- Pattern B — plain config table
		-- (what the old loop expected)
		-- --------------------------------------------
		else
			-- If the table has a nested `config` key, use that as opts
			local opts = mod.config or mod
			opts.capabilities = capabilities

			-- Wrap an existing on_attach so we don't clobber it
			local original_on_attach = opts.on_attach

			opts.on_attach = function(client, bufnr)
				if original_on_attach then
					original_on_attach(client, bufnr)
				end
				-- Fire extender if present in the table
				if type(mod.extend) == "function" then
					mod.extend(client, bufnr)
				end
			end

			vim.lsp.config(server, opts)
			vim.lsp.enable(server)
		end
	else
		-- No custom module — bare-bones setup
		vim.lsp.config(server, { capabilities = capabilities })
		vim.lsp.enable(server)
	end
end

-- Global LspAttach hook for Pattern-A extenders
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspExtenders", { clear = true }),
	desc = "Fire per-language extend() hooks",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		local ext = extenders[client.name]
		if ext then
			ext(client, args.buf)
		end
	end,
})

require("lsp.health")
require("lsp.symbol_index").setup()
require("lsp.diagnostics").setup()
require("lsp.progress").setup()
require("lsp.references").setup()
require("lsp.codelens").setup()
require("lsp.rename").setup()
