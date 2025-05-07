-- Language Server Protocol setup

local lspconfig = require("lspconfig")

-- Example: Python
lspconfig.pyright.setup({})

-- Lua (Neovim internal)
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})

-- Add more language servers as needed...
