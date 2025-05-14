-- lua/core/bootstrap.lua

local M = {}

-- Start high-res timer
M.start_time = (vim.uv or vim.loop).hrtime()

function M.finish()
  local end_time = (vim.uv or vim.loop).hrtime()
  local elapsed_ms = (end_time - M.start_time) / 1e6
  _G.nvim_bootstrap_log = string.format("🚀 Boot in %.2f ms", elapsed_ms)
end

-- -- Measure bootstrap time
-- local start_time = (vim.uv or vim.loop).hrtime()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Report bootstrap time
-- local end_time = (vim.uv or vim.loop).hrtime()
-- local elapsed_ms = (end_time - start_time) / 1e6
-- vim.schedule(function()
--   vim.notify(string.format("⏱️ Neovim bootstrapped in %.2f ms", elapsed_ms), vim.log.levels.INFO)
-- end)

return M
