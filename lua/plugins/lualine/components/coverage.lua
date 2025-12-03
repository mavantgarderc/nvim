local cache = require("plugins.lualine.utils.cache")
local misc = require("plugins.lualine.utils.misc")

local M = {}

local function parse_lcov(s)
	local total, hit = 0, 0
	for line in s:gmatch("[^\r\n]+") do
		local lf = line:match("^LF:(%d+)")
		if lf then
			total = total + tonumber(lf)
		end
		local lh = line:match("^LH:(%d+)")
		if lh then
			hit = hit + tonumber(lh)
		end
	end
	if total == 0 then
		return nil
	end
	return math.floor((hit / total) * 100 + 0.5)
end

local function parse_xml(s)
	local rate = s:match('line%-rate="([%d%.]+)"')
	if rate then
		return math.floor(tonumber(rate) * 100 + 0.5)
	end

	local valid, covered = s:match('lines%-valid="(%d+)".-lines%-covered="(%d+)"')
	if valid and covered and tonumber(valid) > 0 then
		return math.floor((tonumber(covered) / tonumber(valid)) * 100 + 0.5)
	end

	return nil
end

M.coverage = function()
	return cache.get("coverage", function()
		local paths = {
			"coverage/lcov.info",
			"lcov.info",
			"coverage/coverage.xml",
			"coverage.xml",
		}

		for _, p in ipairs(paths) do
			local s = misc.read_file_safe(p, 2 * 1024 * 1024) -- 2MB max
			if s then
				local pct = p:match("lcov%.info") and parse_lcov(s) or parse_xml(s)
				if pct and pct >= 0 then
					return " " .. pct .. "%%"
				end
			end
		end

		return ""
	end, 30000)
end

return M
