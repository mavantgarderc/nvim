-- Treesitter configuration

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"python",
		"json",
		"bash",
		"yaml",
		"markdown",
		"html",
		"css",
		"javascript",
		"c_sharp",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})
