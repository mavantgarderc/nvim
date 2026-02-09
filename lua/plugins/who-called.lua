return {
	"shabaraba/who-called.nvim",
	cmd = {
		"WhoCalled",
		"WhoCalledInspect",
		"WhoCalledHistory",
		"WhoCalledClear",
	},
	keys = {
		{ "<leader>wc", "<cmd>WhoCalled<cr>", desc = "Toggle who-called" },
		{ "<leader>wi", "<cmd>WhoCalledInspect<cr>", desc = "Inspect current window" },
		{ "<leader>wh", "<cmd>WhoCalledHistory<cr>", desc = "Show history" },
		{ "<leader>wC", "<cmd>WhoCalledClear<cr>", desc = "Clear who-called history" },
	},
	opts = {
		enabled = false,
		history_limit = 200,
		show_in_notify = true,
		track_notify = true,
		track_windows = true,
		track_diagnostics = true,
		track_buffers = true,
		hover = false,
		live_inspector = false,
	},
}
