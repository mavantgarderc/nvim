-- Neovim entry point

-- Load editor settings
require("lua.options")

-- Bootstrapping lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("plugins")


-- null_ls loader
local null_ls = require("null-ls")

-- Load plugin configurations
require("custom.lua.plugins.lsp")
require("custom.lua.plugins.cmp")
require("custom.lua.plugins.ui")
require("custom.lua.plugins.gruvbox")
require("custom.lua.plugins.treesitter")
require("custom.lua.plugins.linter")


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
		null_ls.builtins.diagnostics.isort,
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
