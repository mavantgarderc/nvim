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

require("core")

require("lazy").setup("plugins")
