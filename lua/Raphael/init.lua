-- init.lua - Raphael Theme System Main Module
-- Entry point for the Raphael theme system with TOML support

local M = {}

-- Default configuration
local default_config = {
  toml_dir = vim.fn.stdpath("config") .. "/lua/Raphael/colorschemes/",
  default_colorscheme = { name = "midnight_ocean", type = "toml" },
  auto_save = true,
  auto_switch_background = false,
  time_based_switching = false,
  preview = { enabled = true, timeout = 100, restore_on_exit = true },
  picker = { show_type = true, show_preview = true, max_height = 15, max_width = 50, border = "rounded" },
  keymaps = { enabled = true, leader = "<leader>t", global_keys = true, which_key = true, context_aware = true },
  integrations = { telescope = true, lualine = true, nvim_tree = true, which_key = true },
  debug = false,
  validate_on_load = true
}

-- Utilities
local function merge_config(user_config)
  return vim.tbl_deep_extend("force", default_config, user_config or {})
end

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

-- Colorscheme directory
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

local function has_toml_files(path)
  return #vim.fn.glob(path .. "*.toml", false, true) > 0
end

-- Cached modules
local modules = {
  colors = require("Raphael.colors"),
  loader = require("Raphael.scripts.loader"),
  autocmds = require("Raphael.scripts.autocmds"),
  keymaps = require("Raphael.keymaps"),
  cmds = require("Raphael.scripts.cmds"),
  picker = require("Raphael.scripts.picker"),
  cycler = require("Raphael.scripts.cycler"),
  preview = require("Raphael.scripts.preview")
}

-- Sample TOML colorscheme
function M.create_sample_colorscheme(toml_dir)
  local sample_file = toml_dir .. "midnight_ocean.toml"
  local sample_content = [[
# Midnight Ocean TOML colorscheme template
[metadata]
name = "midnight_ocean"
display_name = "Midnight Ocean"
author = "Raphael Theme System"
version = "1.0.0"
description = "A dark blue colorscheme inspired by the depths of the ocean"
background = "dark"

[colors]
bg = "#0a0e1a"
fg = "#a3b8cc"
blue = "#4a9eff"
green = "#34d399"
yellow = "#fbbf24"
red = "#f87171"
purple = "#a78bfa"
]]
  local f = io.open(sample_file, "w")
  if f then
    f:write(sample_content)
    f:close()
    notify("Created sample TOML colorscheme", vim.log.levels.INFO)
  else
    notify("Failed to create sample TOML colorscheme", vim.log.levels.ERROR)
  end
end

local function prepare_colorschemes(config)
  ensure_dir(config.toml_dir)
  if not has_toml_files(config.toml_dir) then
    M.create_sample_colorscheme(config.toml_dir)
  end
end

-- Keymaps setup
local function setup_keymaps(config)
  if not config.keymaps.enabled then return end
  if modules.keymaps.setup_keymaps then modules.keymaps.setup_keymaps(config.keymaps) end
  if config.keymaps.context_aware and modules.keymaps.setup_context_mappings then
    modules.keymaps.setup_context_mappings()
  end
  if modules.keymaps.setup_dynamic_mappings then modules.keymaps.setup_dynamic_mappings() end
  if config.keymaps.which_key and modules.keymaps.setup_which_key_integration then
    modules.keymaps.setup_which_key_integration()
  end
end

-- Autocommands setup with nil checks
local function setup_autocmds(config)
  local a = modules.autocmds
  if not a then return end
  if a.setup_autocmds then a.setup_autocmds() end
  if config.auto_switch_background and a.setup_background_detection then a.setup_background_detection() end
  if config.time_based_switching and a.setup_time_based_switching then a.setup_time_based_switching() end
  if a.setup_session_restore then a.setup_session_restore() end
  if a.setup_toml_validation then a.setup_toml_validation() end
  if a.setup_plugin_integration then a.setup_plugin_integration() end
  if a.setup_file_watchers then a.setup_file_watchers() end
end

-- Apply saved or default colorscheme
local function load_initial_colorscheme(config)
  vim.defer_fn(function()
    local cs
    if config.auto_save and modules.autocmds and modules.autocmds.load_saved_colorscheme then
      cs = modules.autocmds.load_saved_colorscheme()
    end
    if cs then
      if modules.loader and modules.loader.apply_colorscheme then
        modules.loader.apply_colorscheme(cs.name, cs.type)
      end
      if config.debug then notify("Restored colorscheme: " .. cs.name, vim.log.levels.DEBUG) end
    elseif config.default_colorscheme then
      local def = config.default_colorscheme
      if modules.loader and modules.loader.apply_colorscheme then
        modules.loader.apply_colorscheme(def.name, def.type or "toml")
      end
      if config.debug then notify("Applied default colorscheme: " .. def.name, vim.log.levels.DEBUG) end
    end
  end, 100)
end

-- Public API
function M.setup(user_config)
  local config = merge_config(user_config)
  modules.colors.config = vim.tbl_deep_extend("force", modules.colors.config or {}, config)

  prepare_colorschemes(config)

  if config.validate_on_load and modules.loader and modules.loader.validate_all_toml_colorschemes then
    vim.defer_fn(function()
      local results = modules.loader.validate_all_toml_colorschemes()
      if config.debug then
        local valid, total = 0, 0
        for _, r in pairs(results) do
          total = total + 1
          if r.valid then valid = valid + 1 end
        end
        notify("Validated " .. valid .. "/" .. total .. " TOML colorschemes", vim.log.levels.INFO)
      end
    end, 500)
  end

  setup_autocmds(config)
  setup_keymaps(config)
  if modules.cmds and modules.cmds.setup_commands then modules.cmds.setup_commands() end
  load_initial_colorscheme(config)

  vim.g.raphael_config = config
  if config.debug then notify("Raphael Theme System initialized", vim.log.levels.INFO) end
end

function M.quick_setup()
  M.setup({ keymaps = { enabled = true, leader = "<leader>t" }, preview = { enabled = true } })
end

function M.get_config()
  return vim.g.raphael_config or default_config
end

-- Colorscheme management
function M.add_toml_colorscheme(name)
  for _, existing in ipairs(modules.colors.toml_colorschemes or {}) do
    if existing == name then return false, "Colorscheme already exists: " .. name end
  end
  modules.colors.toml_colorschemes = modules.colors.toml_colorschemes or {}
  table.insert(modules.colors.toml_colorschemes, name)
  return true, "Added TOML colorscheme: " .. name
end

function M.remove_toml_colorscheme(name)
  for i, existing in ipairs(modules.colors.toml_colorschemes or {}) do
    if existing == name then
      table.remove(modules.colors.toml_colorschemes, i)
      return true, "Removed: " .. name
    end
  end
  return false, "Colorscheme not found: " .. name
end

function M.create_colorscheme_from_template(name, template_name)
  template_name = template_name or "midnight_ocean"
  local dir = modules.colors.config.toml_dir
  local template_file = dir .. template_name .. ".toml"
  local f = io.open(template_file, "r")
  if not f then
    notify("Template not found: " .. template_name, vim.log.levels.ERROR)
    return false
  end
  local content = f:read("*a"):gsub(template_name, name)
    :gsub('name = "' .. template_name .. '"', 'name = "' .. name .. '"')
  f:close()
  local new_file = io.open(dir .. name .. ".toml", "w")
  if new_file then
    new_file:write(content)
    new_file:close()
    M.add_toml_colorscheme(name)
    notify("Created new TOML colorscheme: " .. name)
    return true
  else
    notify("Failed to create colorscheme file: " .. dir .. name .. ".toml", vim.log.levels.ERROR)
    return false
  end
end

-- Picker & cycling
M.open_picker = function(...) return modules.picker and modules.picker.open_picker and modules.picker.open_picker(...) end
M.cycle_next = function(...) return modules.cycler and modules.cycler.cycle_next and modules.cycler.cycle_next(...) end
M.cycle_previous = function(...) return modules.cycler and modules.cycler.cycle_previous and modules.cycler.cycle_previous(...) end
M.apply_colorscheme = function(...) return modules.loader and modules.loader.apply_colorscheme and modules.loader.apply_colorscheme(...) end
M.preview_colorscheme = function(...) return modules.preview and modules.preview.preview_colorscheme and modules.preview.preview_colorscheme(...) end
M.get_current_colorscheme = function(...) return modules.loader and modules.loader.get_current_colorscheme and modules.loader.get_current_colorscheme(...) end
M.get_all_colorschemes = function(...) return modules.colors and modules.colors.get_all_colorschemes and modules.colors.get_all_colorschemes(...) end

-- Aliases for backward compatibility
M.pick = M.open_picker
M.next = M.cycle_next
M.prev = M.cycle_previous
M.apply = M.apply_colorscheme
M.preview = M.preview_colorscheme

-- Meta
M.version = "1.0.0"
M.author = "Raphael Theme System"

return M
