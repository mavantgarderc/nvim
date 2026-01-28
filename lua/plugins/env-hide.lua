return {
	{
		"MannuVilasara/env-hide.nvim",
		cmd = { "EnvHide", "EnvShow", "EnvToggle" },
		keys = {
			{ "<leader>e?", "<cmd>EnvToggle<cr>", desc = "Env Toggle" },
		},
		opts = {
			env_file_patterns = { "%.env$", "%.env%.local$", "secrets.txt" },
			mask_char = "*",
		},
		config = function(_, opts)
			local env_hide = require("env-hide")
			env_hide.setup(opts)
		end,
	},
}
