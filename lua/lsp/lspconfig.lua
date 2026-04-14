local mason_lspconfig = require("mason-lspconfig")

local capabilities = require("lsp.shared").capabilities

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

local function safe_setup(module_name, opts)
	local ok, mod = pcall(require, module_name)
	if not ok or type(mod) ~= "table" or type(mod.setup) ~= "function" then
		return
	end

	local setup_ok, err = pcall(mod.setup, opts)
	if setup_ok then
		return
	end

	vim.schedule(function()
		vim.notify(string.format("Failed to setup %s: %s", module_name, err), vim.log.levels.ERROR)
	end)
end

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
safe_setup("lsp.symbol_index")
safe_setup("lsp.diagnostics")
safe_setup("lsp.progress")
safe_setup("lsp.references")
safe_setup("lsp.codelens")
safe_setup("lsp.rename")
safe_setup("lsp.code_actions")
safe_setup("lsp.hover")
safe_setup("lsp.inlay_hint")
safe_setup("lsp.lightbulb", { debounce = 150 })
safe_setup("lsp.semantic_tokens")
safe_setup("lsp.virtual_text")
safe_setup("lsp.workspace_symbol")
safe_setup("lsp.implementation")
safe_setup("lsp.type_definition")
safe_setup("lsp.definition_peek")
safe_setup("lsp.call_hierarchy")
safe_setup("lsp.capability_inspector")
safe_setup("lsp.toggle")
safe_setup("lsp.info")
safe_setup("lsp.analytics")
safe_setup("lsp.keymaps")
