-- File: Raphael/scripts/loader.lua
local vim = vim
local fn = vim.fn
local g = vim.g
local cmd = vim.cmd
local api = vim.api
local o = vim.o
local notify = vim.notify
local log = vim.log

local toml_parser = require("Raphael.toml_parser")
local colors_config = require("Raphael.colors")

local M = {}
M.cache = {}

-- ======= Helpers =======

local valid_keys = {
  fg = true,
  bg = true,
  sp = true,
  bold = true,
  underline = true,
  undercurl = true,
  italic = true,
  reverse = true,
  standout = true,
  strikethrough = true,
  nocombine = true
}

local function resolve_color(value, colors)
  if type(value) ~= "string" then return value end
  if value:match("^#%x+$") then return value end
  if colors[value] then return resolve_color(colors[value], colors) end
  return value
end

local function sanitize_hl_name(name)
  return name:gsub("[^%w_]", "_")
end

local function process_highlight(name, hl_def, colors)
  if type(hl_def) == "string" then hl_def = { fg = hl_def } end
  if type(hl_def) ~= "table" then
    notify(("Highlight '%s' is not a table, skipping"):format(name), log.levels.WARN)
    return {}
  end

  local hl = {}
  for key, value in pairs(hl_def) do
    if valid_keys[key] then
      if key == "fg" or key == "bg" or key == "sp" then
        local resolved = resolve_color(value, colors)
        if type(resolved) == "string" and resolved:match("^#%x+$") then
          hl[key] = resolved
        end
      else
        hl[key] = value
      end
    else
      notify(("Invalid highlight key '%s' in '%s'"):format(key, name), log.levels.WARN)
    end
  end
  return hl
end

-- ======= Core Loading =======

function M.load_toml_colorscheme(name)
  if M.cache[name] then return M.cache[name] end

  local filepath = colors_config.config.toml_dir .. name .. ".toml"
  local data, err = toml_parser.load_file(filepath)
  if not data then
    notify(("Failed to load TOML colorscheme '%s': %s"):format(name, err or "unknown error"), log.levels.ERROR)
    return nil
  end

  local valid, validation_err = toml_parser.validate_colorscheme(data)
  if not valid then
    notify(("Invalid TOML colorscheme '%s': %s"):format(name, validation_err), log.levels.ERROR)
    return nil
  end

  local colorscheme = {
    metadata = data.metadata or {},
    colors = data.colors or {},
    highlights = {},
    raw_data = data
  }

  if data.highlights then
    for hl_name, hl_def in pairs(data.highlights) do
      colorscheme.highlights[hl_name] = process_highlight(hl_name, hl_def, data.colors)
    end
  end

  M.cache[name] = colorscheme
  return colorscheme
end

-- ======= Apply Functions =======

function M.apply_toml_colorscheme(name)
  local cs = M.load_toml_colorscheme(name)
  if not cs then return false end

  cmd("hi clear")
  if fn.exists("syntax_on") == 1 then cmd("syntax reset") end

  if cs.metadata.background then o.background = cs.metadata.background end
  g.colors_name = name

  for hl_name, hl_def in pairs(cs.highlights) do
    api.nvim_set_hl(0, sanitize_hl_name(hl_name), hl_def)
  end

  g.raphael_current_colorscheme = {
    name = name,
    type = "toml",
    metadata = cs.metadata
  }

  return true
end

function M.apply_builtin_colorscheme(name)
  g.raphael_current_colorscheme = { name = name, type = "builtin", metadata = {} }
  local ok = pcall(cmd, "colorscheme " .. name)
  if not ok then
    notify("Failed to load built-in colorscheme: " .. name, log.levels.ERROR)
    return false
  end
  return true
end

function M.apply_colorscheme(name, type_)
  if type_ == "toml" then return M.apply_toml_colorscheme(name) end
  return M.apply_builtin_colorscheme(name)
end

-- ======= Utility =======

function M.get_current_colorscheme()
  return g.raphael_current_colorscheme or {
    name = g.colors_name or "default",
    type = "builtin",
    metadata = {}
  }
end

function M.get_colorscheme_metadata(name)
  local cs = M.load_toml_colorscheme(name)
  return cs and cs.metadata or nil
end

function M.get_colorscheme_colors(name)
  local cs = M.load_toml_colorscheme(name)
  return cs and cs.colors or nil
end

function M.reload_toml_colorscheme(name)
  M.cache[name] = nil
  return M.load_toml_colorscheme(name)
end

function M.clear_cache() M.cache = {} end

function M.preview_colorscheme(name, type_)
  local prev = M.get_current_colorscheme()
  return M.apply_colorscheme(name, type_), prev
end

function M.restore_colorscheme(prev)
  if not prev then return false end
  return M.apply_colorscheme(prev.name, prev.type)
end

function M.validate_all_toml_colorschemes()
  local results = {}
  local files = fn.glob(colors_config.config.toml_dir .. "*.toml", false, true)

  for _, file in ipairs(files) do
    local name = fn.fnamemodify(file, ":t:r")
    local cs = M.load_toml_colorscheme(name)
    results[name] = {
      valid = cs ~= nil,
      file = file,
      metadata = cs and cs.metadata or nil
    }
  end

  return results
end

-- ======= Theme Listing =======

function M.get_available_colorschemes()
  local files = fn.glob(colors_config.config.toml_dir .. "*.toml", false, true)
  local themes = {}

  for _, file in ipairs(files) do
    local name = fn.fnamemodify(file, ":t:r")
    local cs = M.load_toml_colorscheme(name)
    if cs then
      table.insert(themes, {
        name = name,
        type = "toml",
        metadata = cs.metadata or {}
      })
    end
  end

  return themes
end

return M
