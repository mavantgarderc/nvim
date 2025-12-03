local map = vim.keymap.set

local M = {}

M.setup = function(lualine_opts)
	local components = require("plugins.lualine.components.init")
	local options = require("plugins.lualine.core.options")

	map("n", "<leader>tk", function()
		components.toggle_filetype_text()
		require("lualine").refresh()
	end, { silent = true })

	map("n", "<leader>tl", function()
		local new_theme = options.get_lualine_theme()
		local current_colorscheme = vim.g.colors_name or "default"
		vim.notify("Scheme: " .. current_colorscheme .. " → Lualine: " .. new_theme, vim.log.levels.INFO)
		lualine_opts.options.theme = new_theme
		require("lualine").setup(lualine_opts)
		require("lualine").refresh()
	end, { silent = true })

	map("n", "<leader>tg", function()
		require("plugins.lualine.components.git").toggle_last_commit()
	end, { desc = "Toggle last commit in lualine" })
end

return M
