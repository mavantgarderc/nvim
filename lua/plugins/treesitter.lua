return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"bash",
				"python",
				"markdown",
				"markdown_inline",
				"html",
				"css",
				"javascript",
				"typescript",
				"json",
				"yaml",
				"toml",
				"dockerfile",
				"sql",
				"regex",
				"query",
				"latex",
			},
			sync_install = false,
			auto_install = true,
			ignore_install = { "phpdoc" },
			highlight = {
				enable = true,
				disable = { "css" },
				additional_vim_regex_highlighting = { "latex" },
			},
			indent = {
				enable = true,
				disable = { "python", "css", "latex" },
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.config").setup(opts)
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "VeryLazy",
		init = function()
			vim.g.skip_ts_context_commentstring_module = true
		end,
		opts = {
			enable_autocmd = false,
			languages = {
				typescript = "// %s",
				javascript = "// %s",
				typescriptreact = { __default = "// %s", jsx = "// %s" },
			},
		},
	},
}
