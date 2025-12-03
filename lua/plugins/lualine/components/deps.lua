local cache = require("plugins.lualine.utils.cache")

local M = {}

local function check_updates()
	if vim.fn.filereadable("package.json") == 1 then
		local out = vim.fn.system("npm outdated --json 2>/dev/null")
		if out ~= "" and out ~= "{}\n" then
			return "󰏗 deps↑"
		end
	elseif vim.fn.filereadable("requirements.txt") == 1 or vim.fn.filereadable("poetry.lock") == 1 then
		local out = vim.fn.system("pip list --outdated --format=columns 2>/dev/null | wc -l")
		if tonumber(out) > 1 then -- first line is header
			return "󰏗 deps↑"
		end
	elseif vim.fn.filereadable("Cargo.lock") == 1 then
		local out = vim.fn.system("cargo outdated --quiet 2>/dev/null | wc -l")
		if tonumber(out) > 0 then
			return "󰏗 deps↑"
		end
	end

	return ""
end

M.deps = function()
	return cache.get("deps", check_updates, 60000) -- 1 min TTL
end

return M
