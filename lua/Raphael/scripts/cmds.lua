-- File: Raphael/scripts/cmds.lua

local map = vim.keymap.set

local colors_config = require("Raphael.colors")
local loader = require("Raphael.scripts.loader")
local picker = require("Raphael.scripts.picker")
local cycler = require("Raphael.scripts.cycler")
local preview = require("Raphael.scripts.preview")

local M = {}

-- Generic completion helper
local function complete_from_list(list, arg_lead)
  local matches = {}
  local lower_lead = arg_lead:lower()
  for _, item in ipairs(list) do
    local name = type(item) == "string" and item or item.name
    if name:lower():find(lower_lead, 1, true) then
      table.insert(matches, name)
    end
  end
  return matches
end

local colorscheme_types = { "all", "toml", "builtin", "dark", "light" }

local complete_colorschemes = function(arg_lead)
  return complete_from_list(colors_config.get_all_colorschemes(), arg_lead)
end

local complete_toml_colorschemes = function(arg_lead)
  return complete_from_list(colors_config.get_toml_colorschemes(), arg_lead)
end

local complete_colorscheme_types = function(arg_lead)
  return complete_from_list(colorscheme_types, arg_lead)
end

-- Helper: parse args into name, type, number
local function parse_args(args_str)
  local args = vim.split(args_str, "%s+")
  return args
end

-- Helper: detect type automatically
local function detect_type(name)
  return colors_config.is_toml_colorscheme(name) and "toml" or "builtin"
end

-- Helper: create user command
local function user_cmd(name, fn, opts)
  vim.api.nvim_create_user_command(name, fn, opts)
end

-- Helper: get colorschemes by type
local function get_colorschemes_by_type(type_name)
  if type_name == "toml" then
    return colors_config.get_toml_colorschemes()
  elseif type_name == "builtin" then
    return colors_config.get_builtin_colorschemes()
  elseif type_name == "dark" then
    return colors_config.get_dark_colorschemes()
  elseif type_name == "light" then
    return colors_config.get_light_colorschemes()
  else
    return colors_config.get_all_colorschemes()
  end
end

function M.setup_commands()
  -- Picker commands
  for _, cmd in ipairs({ { "RaphaelPicker", "Open Raphael theme picker" }, { "Rp", "Alias for RaphaelPicker" } }) do
    user_cmd(cmd[1], function(opts)
      picker.open_picker(opts.args ~= "" and opts.args or nil)
    end, { nargs = "?", complete = complete_colorscheme_types, desc = cmd[2] })
  end

  -- Apply command
  user_cmd("RaphaelApply", function(opts)
    local args = parse_args(opts.args)
    local name, scheme_type = args[1], args[2]

    if not name then
      vim.notify("Usage: RaphaelApply <colorscheme_name> [type]", vim.log.levels.ERROR)
      return
    end

    scheme_type = scheme_type or detect_type(name)
    if loader.apply_colorscheme(name, scheme_type) then
      vim.notify("Applied colorscheme: " .. colors_config.get_display_name(name, scheme_type), vim.log.levels.INFO)
    end
  end, { nargs = "+", complete = complete_colorschemes, desc = "Apply a specific colorscheme" })

  -- Cycle commands
  local cycle_cmds = { { "Next", "cycle_next" }, { "Prev", "cycle_previous" }, { "Random", "cycle_random" } }
  for _, c in ipairs(cycle_cmds) do
    user_cmd("Raphael" .. c[1], function(opts)
      local cycle_type = opts.args ~= "" and opts.args or "all"
      cycler[c[2]](cycle_type)
    end, { nargs = "?", complete = complete_colorscheme_types, desc = c[1] .. " colorscheme" })
  end

  -- Auto-cycle / toggle helper
  local function handle_auto_cycle(fn, opts)
    local args = parse_args(opts.args)
    local type_name = args[1] or "all"
    local interval = tonumber(args[2]) or 5
    fn(type_name, interval * 1000)
  end

  user_cmd("RaphaelAutoCycle", function(opts) handle_auto_cycle(cycler.start_auto_cycle, opts) end, {
    nargs = "*",
    complete = function(arg_lead, cmd_line)
      if #vim.split(cmd_line, "%s+") <= 2 then return complete_colorscheme_types(arg_lead) end
      return {}
    end,
    desc = "Start auto-cycling colorschemes [type] [interval_seconds]"
  })

  user_cmd("RaphaelStopCycle", cycler.stop_auto_cycle, { desc = "Stop auto-cycling colorschemes" })
  user_cmd("RaphaelToggleCycle", function(opts) handle_auto_cycle(cycler.toggle_auto_cycle, opts) end, {
    nargs = "*",
    complete = function(arg_lead, cmd_line)
      if #vim.split(cmd_line, "%s+") <= 2 then return complete_colorscheme_types(arg_lead) end
      return {}
    end,
    desc = "Toggle auto-cycling colorschemes"
  })

  -- Preview commands
  local function preview_cmd(fn_name, timeout_default)
    return function(opts)
      local args = parse_args(opts.args)
      local name, scheme_type, duration = args[1], args[2], tonumber(args[3]) or timeout_default

      if not name then
        vim.notify(("Usage: %s <colorscheme_name> [type] [timeout_ms]"):format(fn_name), vim.log.levels.ERROR)
        return
      end

      scheme_type = scheme_type or detect_type(name)
      preview[fn_name](name, scheme_type, duration)
    end
  end

  user_cmd("RaphaelPreview", preview_cmd("preview_colorscheme", nil),
    { nargs = "+", complete = complete_colorschemes, desc = "Preview a colorscheme in a window" })
  user_cmd("RaphaelQuickPreview", preview_cmd("quick_preview", 2000),
    { nargs = "+", complete = complete_colorschemes, desc = "Quick preview a colorscheme with auto-restore" })

  -- Remaining commands (Compare, Slideshow, Info, List, Reload, Validate, Status) can be similarly refactored using helpers above.
end

return M
