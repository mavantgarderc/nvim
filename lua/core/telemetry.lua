-- ============================================================================
-- Telemetry — core/telemetry.lua
-- ============================================================================
-- Track and log:
-- ▸ Neovim startup performance
-- ▸ Plugin load times
-- ▸ Custom user-defined events and actions
-- ============================================================================
local api = vim.api
local fn = vim.fn
local start_time = vim.loop.hrtime()

-- ============================================================================
-- Track Neovim startup time
api.nvim_create_autocmd("VimEnter", {
  desc = "Track Neovim startup time",
  callback = function()
    local elapsed = (vim.loop.hrtime() - start_time) / 1e6
    vim.notify("⏳ Neovim Startup Time: " .. string.format("%.2f", elapsed) .. "ms", vim.log.levels.INFO)
  end,
})

-- ============================================================================
-- Plugin Load Time Logging (Lazy.nvim)
local function log_plugin_load_time(plugin_name)
  local plugin_time = vim.loop.hrtime()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyPluginLoadDone",
    callback = function()
      local elapsed = (vim.loop.hrtime() - plugin_time) / 1e6
      vim.notify("Plugin Loaded: " .. plugin_name .. " in " .. string.format("%.2f", elapsed) .. "ms", vim.log.levels.INFO)
    end,
  })
end

-- ============================================================================
-- Lazy.nvim Plugin Load Timing (for Lazy plugin manager)
local lazy = pcall(require, "lazy")
lazy.setup({
  install = {
    -- Example for logging plugin load times
    {
      "telescope.nvim",
      config = function()
        log_plugin_load_time("telescope.nvim")
      end,
    },
    -- More plugins can be added here
  },
})

-- ============================================================================
-- Track key events (user-defined)
api.nvim_create_autocmd("User", {
  pattern = "KeyPress",
  desc = "Log key press events",
  callback = function()
    vim.notify("🔑 Key Press Detected: " .. vim.fn.expand("<cword>"), vim.log.levels.DEBUG)
  end,
})

-- ============================================================================
-- Telemetry for custom actions
vim.api.nvim_create_user_command("TelemetryStatus", function()
  local elapsed = (vim.loop.hrtime() - start_time) / 1e6
  vim.notify("🕒 Neovim startup time: " .. string.format("%.2f", elapsed) .. "ms", vim.log.levels.INFO)
end, { desc = "Show Neovim telemetry status" })

-- ============================================================================
-- 🧠 Telemetry tracking initialized
-- ============================================================================