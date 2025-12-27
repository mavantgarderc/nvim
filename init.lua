local config_path = vim.fn.stdpath("config")
local cwd = vim.fn.getcwd()
local rtp = vim.opt.runtimepath:get()
if not vim.tbl_contains(rtp, config_path) then
	vim.opt.runtimepath:append(config_path)
end
if not vim.tbl_contains(rtp, cwd) then
	vim.opt.runtimepath:append(cwd)
end

vim.loader.enable()

local function load_env_file(path)
	local f = io.open(path, "r")
	if not f then
		return
	end
	for line in f:lines() do
		line = line:gsub("#.*$", "")
		line = line:match("^%s*(.-)%s*$")
		if line ~= "" then
			local key, value = line:match("^([A-Za-z_][A-Za-z0-9_]*)%s*=%s*(.+)$")
			if key and value then
				value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
				vim.env[key] = value
			end
		end
	end
	f:close()
end

load_env_file(config_path .. "/.env")
load_env_file(config_path .. "/.env.local")

local lazy_dev = nil
do
	local dev_path = vim.env.LAZY_DEV_PATH
	if dev_path and dev_path ~= "" then
		if dev_path:sub(1, 2) == "~/" then
			dev_path = vim.fn.expand(dev_path)
		end
		local patterns_raw = vim.env.LAZY_DEV_PATTERNS or ""
		local patterns = {}
		if patterns_raw ~= "" then
			patterns = vim.split(patterns_raw, ",", { trimempty = true })
		end
		local fallback = (vim.env.LAZY_DEV_FALLBACK == "true")
		lazy_dev = {
			path = dev_path,
			patterns = (#patterns > 0) and patterns or { "mavantgarderc" },
			fallback = fallback,
		}
	end
end

require("core")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.lspconfig" },
		{ import = "plugins.cmpconfig" },
	},
	dev = lazy_dev,
})
