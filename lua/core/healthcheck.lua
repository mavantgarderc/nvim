local M = {}

local function plugin_installed(name)
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/" .. name
  return vim.fn.isdirectory(lazy_path) == 1
end

local function config_check()
  local ok, err = pcall(function()
    vim.cmd("source $MYVIMRC")
  end)
  return ok, err
end

function M.run()
  print("=== [Healthcheck: nvim config + lazy.nvim] ===")

  local cfg_ok, cfg_err = config_check()
  if cfg_ok then
    print("[OK] Neovim config loads with no errors.")
  else
    print("[FAIL] Error in Neovim config: " .. (cfg_err or "Unknown"))
  end

  local critical_plugins = { "nvim-treesitter", "nvim-lspconfig", "plenary.nvim", "lazy.nvim" }
  local missing = {}
  for _, plugin in ipairs(critical_plugins) do
    if not plugin_installed(plugin) then
      table.insert(missing, plugin)
    end
  end
  if #missing == 0 then
    print("[OK] All critical plugins are installed (lazy.nvim).")
  else
    print("[FAIL] Missing plugins (lazy.nvim): " .. table.concat(missing, ", "))
  end

  print("=== Healthcheck Complete ===")
end

if vim.g.loaded_core_healthcheck_himp ~= 1 then
  vim.api.nvim_create_user_command("Himp", function()
    require("core.healthcheck").run()
  end, {})
  vim.g.loaded_core_healthcheck_himp = 1
end

return M
