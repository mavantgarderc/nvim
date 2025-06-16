-- copied from kickstart.nvim & add some
local M = {}

-- Check Neovim version
local function check_version()
  local ver = vim.version()
  if not vim.version.ge then
    return false, "Neovim out of date (pre-0.10)"
  end
  return vim.version.ge(ver, {0, 10, 0}),
         string.format("Neovim version: %d.%d.%d", ver.major, ver.minor, ver.patch)
end

-- Check external dependencies
local function check_external_reqs()
  local results = {}
  for _, exe in ipairs {"git", "make", "unzip", "rg"} do
    local ok = vim.fn.executable(exe) == 1
    table.insert(results, {
      ok = ok,
      message = ok and ("Found executable: "..exe) or ("Missing executable: "..exe)
    })
  end
  return results
end

-- Check if plugin is installed
local function plugin_installed(name)
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/" .. name
  return vim.fn.isdirectory(lazy_path) == 1
end

-- Check config load
local function config_check()
  local ok, err = pcall(vim.cmd, "source $MYVIMRC")
  return ok, ok and "Config loads successfully" or ("Config error: "..tostring(err))
end

-- Combined health check
function M.check()
  -- Kickstart-style checks
  local version_ok, version_msg = check_version()
  local external_reqs = check_external_reqs()

  -- User config checks
  local config_ok, config_msg = config_check()
  local critical_plugins = {"nvim-treesitter", "nvim-lspconfig", "plenary.nvim", "lazy.nvim"}
  local missing_plugins = {}

  for _, plugin in ipairs(critical_plugins) do
    if not plugin_installed(plugin) then
      table.insert(missing_plugins, plugin)
    end
  end

  -- Format results
  local results = {
    {header = "=== SYSTEM & DEPENDENCIES ==="},
    {ok = version_ok, message = version_msg},
    {header = "=== EXTERNAL DEPENDENCIES ==="},
  }

  for _, req in ipairs(external_reqs) do
    table.insert(results, req)
  end

  table.insert(results, {header = "=== USER CONFIG ==="})
  table.insert(results, {ok = config_ok, message = config_msg})

  table.insert(results, {header = "=== CRITICAL PLUGINS ==="})
  if #missing_plugins == 0 then
    table.insert(results, {ok = true, message = "All critical plugins installed"})
  else
    table.insert(results, {
      ok = false,
      message = "Missing plugins: " .. table.concat(missing_plugins, ", ")
    })
  end

  return results
end

-- Run healthcheck and display results
function M.run()
  local results = M.check()

  print("=== NVIM CONFIG HEALTH CHECK ===")
  for _, item in ipairs(results) do
    if item.header then
      print("\n" .. item.header)
    else
      print((item.ok and "[✓] " or "[✗] ") .. item.message)
    end
  end
  print("\n=== CHECK COMPLETE ===")
end

-- Create commands
if not vim.g.loaded_core_healthcheck then
  vim.api.nvim_create_user_command("Himp", M.run, {desc = "Run config health check"})

  vim.api.nvim_create_user_command("CheckhealthConfig", function()
    -- Display in quickfix window
    local results = M.check()
    local qf_list = {}

    for _, item in ipairs(results) do
      if item.header then
        table.insert(qf_list, {
          text = item.header,
          type = "I" -- Info
        })
      else
        table.insert(qf_list, {
          text = item.message,
          type = item.ok and "I" or "E" -- Info/Error
        })
      end
    end

    vim.fn.setqflist(qf_list)
    vim.cmd("copen")
  end, {desc = "Detailed config health check"})

  vim.g.loaded_core_healthcheck = true
end

return M
