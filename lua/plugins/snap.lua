return {
	{
		"mistweaverco/snap.nvim",
		opts = {
			timeout = 5000,
			output_dir = "$HOME/Pictures",
			filename_pattern = "origavim_%t.png",

			font_settings = {
				default = {
					name = "Cascadia Cove Nerd Font",
					file = nil,
					size = 12,
					line_height = 1.25,
				},
				italic = {
					name = "Cascadia Cove Nerd Font Italic",
					file = nil,
					size = 12,
					line_height = 1.25,
				},
			},
		},
	},
}
