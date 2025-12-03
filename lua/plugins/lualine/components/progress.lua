local glyphs = require("plugins.lualine.utils.glyphs")

return function()
	local chars = glyphs.progress
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local index = math.ceil((current_line / total_lines) * #chars)
	return chars[index] or chars[#chars]
end
