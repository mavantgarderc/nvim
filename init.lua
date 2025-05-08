-- Neovim entry point

-- Load editor settings
require("lua.options")

-- Bootstrap and setup lazy.nvim plugins
require("lua.lua")

-- Load plugin configurations
require("lua.plugins.lsp")
require("lua.plugins.cmp")
require("lua.plugins.ui")
require("lua.plugins.gruvbox")
require("lua.plugins.treesitter")

-- my addons
vim.g.loaded_perl_provider = 0 -- disable perl 
vim.g.python3_host_prog = "/home/mava/venv/bin/python"
-- for Python LSP (Pyright)
-- Set up Python LSP (Pyright)
local lspconfig = require("lua.plugins.lsp")

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
