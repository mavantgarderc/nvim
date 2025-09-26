-- File: Raphael/scripts/autocmds.lua

local colors_config = require("Raphael.colors")
local loader = require("Raphael.scripts.loader")

local M = {}

-- Helpers
local function get_current_colorscheme()
  if loader.get_current_colorscheme and type(loader.get_current_colorscheme) == "function" then
    return loader.get_current_colorscheme() or {}
  end
  return {}
end

local function safe_defer(fnc, delay)
  if type(fnc) == "function" then vim.defer_fn(fnc, delay or 0) end
end

-- Save current colorscheme state
function M.save_current_colorscheme()
  local cur = get_current_colorscheme()
  if not cur.name then return end
  local path = vim.fn.stdpath("config") .. "/raphael_state.lua"
  local f, err = io.open(path, "w")
  if not f then
    return vim.notify("Failed to save colorscheme: " .. (err or ""), vim.log.levels.ERROR)
  end
  f:write(string.format(
    "return { last_colorscheme = { name = %q, type = %q, timestamp = %d } }",
    cur.name, cur.type, os.time()
  ))
  f:close()
end

function M.load_saved_colorscheme()
  local path = vim.fn.stdpath("config") .. "/raphael_state.lua"
  local ok, saved = pcall(dofile, path)
  if not ok or not saved or not saved.last_colorscheme then return nil end

  local all = {}
  if colors_config.get_all_colorschemes and type(colors_config.get_all_colorschemes) == "function" then
    all = colors_config.get_all_colorschemes()
  end

  for _, cs in ipairs(all) do
    if cs.name == saved.last_colorscheme.name and cs.type == saved.last_colorscheme.type then
      return saved.last_colorscheme
    end
  end
  return nil
end

-- Terminal colors sync
function M.sync_terminal_colors(name)
  local cs = loader.get_colorscheme_colors and loader.get_colorscheme_colors(name or get_current_colorscheme().name)
  if not cs then return end

  local t = {
    cs.bg, cs.red, cs.green, cs.yellow, cs.blue, cs.purple, cs.cyan, cs.fg,
    cs.comment, cs.red, cs.green, cs.yellow, cs.blue, cs.purple, cs.cyan, cs.fg
  }
  for i, c in ipairs(t) do vim.g["terminal_color_" .. (i - 1)] = c end
end

-- Main autocmd setup
function M.setup_autocmds()
  local augroup = vim.api.nvim_create_augroup("Raphael", { clear = true })

  -- Track colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    callback = function()
      local current_name = vim.g.colors_name
      if not current_name then return end

      local is_toml = false
      if colors_config.is_toml_colorscheme and type(colors_config.is_toml_colorscheme) == "function" then
        is_toml = colors_config.is_toml_colorscheme(current_name)
      end

      vim.g.raphael_current_colorscheme = {
        name = current_name,
        type = is_toml and "toml" or "builtin",
        timestamp = os.time(),
      }

      if colors_config.config and colors_config.config.auto_save then
        M.save_current_colorscheme()
      end
    end,
    desc = "Track colorscheme changes",
  })

  -- Load default colorscheme on startup
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
      if not vim.g.colors_name or vim.g.colors_name == "default" then
        local def = colors_config.config and colors_config.config.default_colorscheme
        if def and def.name and loader.apply_colorscheme then
          safe_defer(function() loader.apply_colorscheme(def.name, def.type or "toml") end, 100)
        end
      end
    end,
    desc = "Auto-load default colorscheme",
  })

  -- Auto-reload TOML colorschemes on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    pattern = (colors_config.config and colors_config.config.toml_dir or "") .. "*.toml",
    callback = function(event)
      local filename = vim.fn.fnamemodify(event.file, ":t:r")
      if loader.cache then loader.cache[filename] = nil end
      vim.notify("Reloaded TOML colorscheme: " .. filename, vim.log.levels.INFO)
      local current = get_current_colorscheme()
      if current.name == filename and current.type == "toml" and loader.apply_colorscheme then
        safe_defer(function() loader.apply_colorscheme(filename, "toml") end, 100)
      end
    end,
    desc = "Auto-reload TOML colorschemes",
  })

  -- Terminal sync
  vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
      local cs = get_current_colorscheme()
      if cs.type == "toml" then M.sync_terminal_colors() end
    end,
    desc = "Sync terminal colors with TOML colorscheme",
  })

  -- Refresh previews on window/buffer enter
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = augroup,
    callback = function()
      local preview = package.loaded["Raphael.scripts.preview"] and require("Raphael.scripts.preview")
      if preview and preview.get_preview_status and preview.get_preview_status().active_previews > 0 then
        safe_defer(function() vim.cmd("syntax sync fromstart") end, 10)
      end
    end,
    desc = "Refresh preview highlighting",
  })

  -- Auto-switch background
  vim.api.nvim_create_autocmd("OptionSet", {
    group = augroup,
    pattern = "background",
    callback = function()
      if not (colors_config.config and colors_config.config.auto_switch_background) then return end
      local current = get_current_colorscheme()
      if current.type ~= "toml" then return end

      local bg = vim.o.background
      local metadata = loader.get_colorscheme_metadata and loader.get_colorscheme_metadata(current.name)
      if metadata and metadata.background ~= bg then
        local schemes = {}
        if bg == "dark" and colors_config.get_dark_colorschemes then
          schemes = colors_config.get_dark_colorschemes()
        elseif bg == "light" and colors_config.get_light_colorschemes then
          schemes = colors_config.get_light_colorschemes()
        end
        if #schemes > 0 and loader.apply_colorscheme then
          loader.apply_colorscheme(schemes[1].name, schemes[1].type)
        end
      end
    end,
    desc = "Auto-switch colorscheme based on background",
  })

  -- Time-based switching
  if colors_config.config and colors_config.config.time_based_switching then
    local function switch_time_based()
      local hour = tonumber(os.date("%H"))
      local is_day = hour >= 6 and hour < 18

      local schemes = {}
      if is_day and colors_config.get_light_colorschemes then
        schemes = colors_config.get_light_colorschemes()
      elseif not is_day and colors_config.get_dark_colorschemes then
        schemes = colors_config.get_dark_colorschemes()
      end
      if #schemes == 0 then return end

      local current = get_current_colorscheme()
      if current.name ~= schemes[1].name and loader.apply_colorscheme then
        loader.apply_colorscheme(schemes[1].name, schemes[1].type)
      end
    end

    vim.api.nvim_create_autocmd("VimEnter",
      { group = augroup, callback = function() safe_defer(switch_time_based, 1000) end })
    local timer = vim.loop.new_timer()
    timer:start(3600000, 3600000, vim.schedule_wrap(switch_time_based))
    vim.api.nvim_create_autocmd("VimLeavePre", { group = augroup, callback = function()
      timer:stop(); timer:close()
    end })
  end
end

return M
