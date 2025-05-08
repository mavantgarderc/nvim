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

-- Python LSP setup with Pyright
lspconfig.pyright.setup({
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic", -- Or "strict" for strict checking
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
})

-- Add more language servers as needed...
