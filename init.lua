-- Neovim entry point

-- Load editor settings
require("settings")

-- Bootstrap and setup lazy.nvim plugins
require("lazy")

-- Load plugin configurations
require("custom.lua.plugins.lsp")
require("custom.lua.plugins.cmp")
require("custom.lua.plugins.ui")
require("custom.lua.plugins.treesitter")




-- my addons
vim.g.loaded_perl_provider = 0
vim.g.python3_host_prog = "/home/mava/venv/bin/python"
-- for Python LSP (Pyright)
-- Set up Python LSP (Pyright)
local lspconfig = require("lspconfig")

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

-- Format on save with black
vim.cmd([[
  augroup FormatOnSave
    autocmd!
    autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync()
  augroup END
]])

-- Install and configure linters with null-ls
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- Python linters
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.pylint,
	},
})

-- Enable `telescope` for easy searching of Python files
local telescope = require("telescope")
telescope.setup({
	defaults = {
		prompt_prefix = "🔍 ",
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})

-- Keybinding for running Python tests in tmux pane or terminal
vim.api.nvim_set_keymap(
	"n",
	"<Leader>t",
	':TermExec cmd="pytest" direction=horizontal<CR>',
	{ noremap = true, silent = true }
)

-- Add GitHub Copilot if installed (optional for code suggestions)
-- require('copilot').setup({
--   suggestion = { enabled = true },
--   panel = { enabled = true },
-- })
--
--
--
