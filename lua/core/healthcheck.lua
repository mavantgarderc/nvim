local M = {}

-- `:HealthCheck`:
--       full detailed report with all checks displayed in the command area
-- `:HealthSummary`:
--       quick overview showing pass/fail counts & overall status
-- `:HealthQuickfix`:
--       opens quickfix window with all results; navigate by `[q` & `]q`

local ver = vim.version()

-- CONFIGURATION - MODIFY THIS SECTION TO CUSTOMIZE
local config = {
  min_version = { 0, 10, 0 },

  external_deps = {
    required = {
      "git",
      "make",
      "unzip",
    },

    optional = {
      "rg",
      "fd",
      "fzf",
      "node",
      "python3",
      "curl",
      "wget",
    },
  },

  critical_plugins = {
    "nvim-treesitter",
    "nvim-lspconfig",
    "plenary.nvim",
    "lazy.nvim",
  },

  language_servers = {
    "lua_ls",
    "pyright",
    "ts_ls",
    "rust_analyzer",
    "gopls",
    "clangd",
    "bashls",
    "jsonls",
  },
}

local function format_version(v) return string.format("%d.%d.%d", v.major or 0, v.minor or 0, v.patch or 0) end

local function get_plugin_manager()
  local managers = {
    { name = "lazy.nvim", path = vim.fn.stdpath("data") .. "/lazy" },
    { name = "packer.nvim", path = vim.fn.stdpath("data") .. "/site/pack/packer" },
    { name = "vim-plug", check = function() return vim.g.loaded_plug ~= nil end },
  }

  for _, manager in ipairs(managers) do
    if manager.check and manager.check() then
      return manager.name
    elseif manager.path and vim.fn.isdirectory(manager.path) == 1 then
      return manager.name
    end
  end
  return nil
end

local function check_version()
  if not ver.ge then return false, "Neovim version API unavailable (very old version)" end

  local is_compatible = ver.ge(ver, config.min_version)
  local current_version = format_version(ver)
  local min_version = format_version({
    major = config.min_version[1],
    minor = config.min_version[2],
    patch = config.min_version[3],
  })

  return is_compatible,
    string.format("Neovim %s (minimum: %s) - %s", current_version, min_version, is_compatible and "Compatible" or "Outdated")
end

local function check_external_deps()
  local results = {}

  for _, exe in ipairs(config.external_deps.required) do -- Required dependencies
    local ok = vim.fn.executable(exe) == 1
    table.insert(results, {
      ok = ok,
      critical = true,
      message = string.format("%s %s (required)", exe, ok and "OK" or "MISSING"),
    })
  end
  for _, exe in ipairs(config.external_deps.optional) do -- Optional dependencies
    local ok = vim.fn.executable(exe) == 1
    table.insert(results, {
      ok = ok,
      critical = false,
      message = string.format("%s %s (optional)", exe, ok and "OK" or "-"),
    })
  end

  return results
end

local function plugin_installed(name, manager)
  if manager == "lazy.nvim" then
    local lazy_path = vim.fn.stdpath("data") .. "/lazy/" .. name
    return vim.fn.isdirectory(lazy_path) == 1
  elseif manager == "packer.nvim" then
    local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/" .. name
    return vim.fn.isdirectory(packer_path) == 1
  end
  return false
end

local function check_plugins()
  local manager = get_plugin_manager()
  local results = {}

  if not manager then return {
    { ok = false, message = "No plugin manager detected" },
  } end

  table.insert(results, {
    ok = true,
    message = string.format("Plugin manager: %s OK", manager),
  })

  local missing_plugins = {}
  local installed_count = 0

  for _, plugin in ipairs(config.critical_plugins) do
    if plugin_installed(plugin, manager) then
      installed_count = installed_count + 1
    else
      table.insert(missing_plugins, plugin)
    end
  end

  if #missing_plugins == 0 then
    table.insert(results, {
      ok = true,
      message = string.format("All %d critical plugins installed OK", #config.critical_plugins),
    })
  else
    table.insert(results, {
      ok = false,
      message = string.format(
        "Missing %d/%d plugins: %s",
        #missing_plugins,
        #config.critical_plugins,
        table.concat(missing_plugins, ", ")
      ),
    })
  end

  return results
end

local function check_lsp_servers()
  local results = {}
  local available_servers = {}
  local missing_servers = {}

  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then return {
    { ok = false, message = "nvim-lspconfig not available" },
  } end

  for _, server in ipairs(config.language_servers) do
    local server_available = false
    if lspconfig[server] and lspconfig[server].vim.cmd then
      local cmd_name = lspconfig[server].vim.cmd[1]
      if vim.fn.executable(cmd_name) == 1 then
        server_available = true
        table.insert(available_servers, server)
      end
    end

    if not server_available then table.insert(missing_servers, server) end
  end

  table.insert(results, {
    ok = true,
    message = string.format("LSP servers available: %d/%d", #available_servers, #config.language_servers),
  })

  if #available_servers > 0 then
    table.insert(results, {
      ok = true,
      message = "Available: " .. table.concat(available_servers, ", "),
    })
  end

  if #missing_servers > 0 then
    table.insert(results, {
      ok = false,
      message = "Missing: " .. table.concat(missing_servers, ", "),
    })
  end

  return results
end

local function check_config()
  local results = {}

  local config_ok, config_err = pcall(vim.cmd, "source $MYVIMRC")
  table.insert(results, {
    ok = config_ok,
    message = config_ok and "Configuration loads successfully OK" or ("Configuration error: " .. tostring(config_err)),
  })

  local config_files = {
    { path = vim.fn.stdpath("config") .. "/init.lua", name = "init.lua" },
    { path = vim.fn.stdpath("config") .. "/init.vim", name = "init.vim" },
  }

  local found_config = false
  for _, file in ipairs(config_files) do
    if vim.fn.filereadable(file.path) == 1 then
      table.insert(results, {
        ok = true,
        message = string.format("Found config file: %s OK", file.name),
      })
      found_config = true
    end
  end

  if not found_config then
    table.insert(results, {
      ok = false,
      message = "No main config file found (init.lua or init.vim)",
    })
  end

  local data_dir = vim.fn.stdpath("data")
  local data_writable = vim.fn.filewritable(data_dir) == 2
  table.insert(results, {
    ok = data_writable,
    message = string.format("Data directory writable: %s %s", data_dir, data_writable and "OK" or "FAIL"),
  })

  return results
end

local function get_system_info()
  return {
    os = vim.loop.os_uname().sysname,
    nvim_version = format_version(ver),
    config_dir = vim.fn.stdpath("config"),
    data_dir = vim.fn.stdpath("data"),
    plugin_manager = get_plugin_manager() or "none detected",
  }
end

function M.check()
  local version_ok, version_msg = check_version()
  local external_deps = check_external_deps()
  local plugin_results = check_plugins()
  local lsp_results = check_lsp_servers()
  local config_results = check_config()
  local system_info = get_system_info()

  local results = {
    { header = "=== SYSTEM INFORMATION ===", info = system_info },
    { ok = version_ok, message = version_msg },

    { header = "=== EXTERNAL DEPENDENCIES ===" },
  }

  for _, dep in ipairs(external_deps) do
    table.insert(results, dep)
  end

  table.insert(results, { header = "=== PLUGIN MANAGER & CRITICAL PLUGINS ===" })
  for _, result in ipairs(plugin_results) do
    table.insert(results, result)
  end

  table.insert(results, { header = "=== LANGUAGE SERVERS ===" })
  for _, result in ipairs(lsp_results) do
    table.insert(results, result)
  end

  table.insert(results, { header = "=== CONFIGURATION ===" })
  for _, result in ipairs(config_results) do
    table.insert(results, result)
  end

  return results
end

function M.run()
  local results = M.check()
  print("+=========================================+")
  print("|        NVIM CONFIG HEALTH CHECK         |")
  print("+=========================================+")

  for _, item in ipairs(results) do
    if item.header then
      print(string.format("\n%s", item.header))
      if item.info then
        for key, value in pairs(item.info) do
          print(string.format("  %s: %s", key, value))
        end
      end
    else
      local icon = item.ok and "[OK] " or (item.critical == false and "[WARN]" or "[FAIL]")
      print(string.format("%s %s", icon, item.message))
    end
  end

  print("\n+=========================================+")
  print("|            CHECK COMPLETE               |")
  print("+=========================================+")
end

function M.summary()
  local results = M.check()
  local total_checks = 0
  local passed_checks = 0
  local critical_failed = 0

  for _, item in ipairs(results) do
    if item.ok ~= nil then
      total_checks = total_checks + 1
      if item.ok then
        passed_checks = passed_checks + 1
      elseif item.critical ~= false then
        critical_failed = critical_failed + 1
      end
    end
  end

  local health_status = "HEALTHY"
  if critical_failed > 0 then
    health_status = "CRITICAL ISSUES"
  elseif passed_checks < total_checks then
    health_status = "MINOR ISSUES"
  end

  print(string.format("Health Status: %s", health_status))
  print(string.format("Checks: %d/%d passed", passed_checks, total_checks))
  if critical_failed > 0 then print(string.format("Critical failures: %d", critical_failed)) end
end

function M.get_results() return M.check() end

local function setup_commands()
  if vim.g.loaded_nvim_healthcheck then return end

  vim.api.nvim_create_user_command("HealthCheck", M.run, {
    desc = "Run comprehensive Neovim configuration health check",
  })

  vim.api.nvim_create_user_command("HealthSummary", M.summary, {
    desc = "Show health check summary",
  })

  vim.api.nvim_create_user_command("HealthQuickfix", function()
    local results = M.check()
    local qf_list = {}

    for _, item in ipairs(results) do
      if item.header then
        table.insert(qf_list, {
          text = item.header,
          type = "I",
        })
      elseif item.ok ~= nil then
        table.insert(qf_list, {
          text = item.message,
          type = item.ok and "I" or (item.critical == false and "W" or "E"),
        })
      end
    end

    vim.fn.setqflist(qf_list, "r")
    vim.cmd("copen")
    print("Health check results loaded in quickfix list")
  end, { desc = "Load health check results in quickfix list" })

  vim.api.nvim_create_user_command("HealthAutoCheck", function()
    vim.defer_fn(function()
      local results = M.check()
      local has_critical_issues = false

      for _, item in ipairs(results) do
        if item.ok == false and item.critical ~= false then
          has_critical_issues = true
          break
        end
      end

      if has_critical_issues then
        vim.notify("WARNING: Critical configuration issues detected! Run :HealthCheck for details", vim.log.levels.WARN)
      end
    end, 1000)
  end, { desc = "Run automatic health check on startup" })

  vim.g.loaded_nvim_healthcheck = true
end

local function check_custom_config()
  local results = {}

  local colorscheme_ok = pcall(vim.cmd, "colorscheme catppuccin")
  table.insert(results, {
    ok = colorscheme_ok,
    message = colorscheme_ok and "Colorscheme available" or "Default colorscheme missing",
  })

  local leader = vim.g.mapleader or "\\"
  table.insert(results, {
    ok = leader ~= "\\",
    message = string.format("Leader key: '%s' %s", leader, leader ~= "\\" and "OK" or "(default)"),
  })

  return results
end

function M.setup(user_config)
  if user_config then config = vim.tbl_deep_extend("force", config, user_config) end
  setup_commands()
end

setup_commands()

return M
