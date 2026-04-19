return {
	"mavantgarderc/prismpunk.nvim",
	lazy = false,
	priority = 900,

	config = function()
		require("prismpunk").setup({
			-- scheme = "kanagawa/paper/pebble",

			-- themes = {
			-- 	"kanagawa",
			-- 	"tmnt",
			-- 	"dc",
			-- 	-- "detox",
			-- 	-- "punk-cultures",
			-- 	"nvim-builtins",
			-- },

			styles = {
				comments = { italic = true },
				keywords = { bold = false },
				functions = { bold = true },
				variables = {},
			},

			overrides = {
				colors = {},
				highlights = {},
			},

			integrations = {
				cmp = true,
				telescope = true,
				gitsigns = true,
				lualine = true,
			},

			terminals = {
				enabled = true,
				emulator = { "alacritty", "ghostty" },
				ghostty = {
					enabled = true,
					auto_reload = true,
					config_path = vim.fn.expand("~/.config/ghostty/themes/prismpunk.toml"),
				},
				alacritty = {
					enabled = true,
					auto_reload = true,
					config_path = vim.fn.expand("~/.config/alacritty/prismpunk.toml"),
				},
			},
		})
	end,
}
