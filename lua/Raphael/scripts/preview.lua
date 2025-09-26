-- File: Raphael/scripts/preview.lua

local map = vim.keymap.set

local colors_config = require("Raphael.colors")
local loader = require("Raphael.scripts.loader")

local M = {}

-- Preview state
local preview_state = {
  active_previews = {},
  original_colorscheme = nil,
  preview_timeout = nil,
  sample_content = nil
}

-- Sample content for previews
local function get_sample_content()
  if preview_state.sample_content then return preview_state.sample_content end

  preview_state.sample_content = {
    "-- Raphael Theme Preview",
    "-- This window shows how the colorscheme looks with syntax highlighting",
    "",
    "-- Comments and documentation",
    '-- TODO: Add more features',
    '-- FIXME: Handle edge cases',
    '-- NOTE: This is just a preview',
    "",
    "-- Variables and constants",
    "local config = {",
    '  theme = "midnight_ocean",',
    "  version = 1.0,",
    "  enabled = true,",
    "  features = { 'syntax', 'lsp', 'treesitter' }",
    "}",
    "",
    "-- Functions and methods",
    "local function setup_colorscheme(name, options)",
    '  print("Setting up colorscheme: " .. name)',
    "  if not options then error('Options are required!') end",
    "  for k,v in pairs(options) do config[k]=v end",
    "  return config",
    "end",
    "",
    "-- Control flow",
    "if config.enabled then",
    "  local result = setup_colorscheme('test', {background='dark', transparency=false})",
    "  while result.loading do vim.wait(100) end",
    "else vim.notify('Colorscheme disabled', vim.log.levels.WARN) end",
    "",
    "-- Classes and types (simulated)",
    "---@class ThemeConfig",
    "---@field name string",
    "---@field background 'light'|'dark'",
    "local ThemeConfig={}",
    "function ThemeConfig:new(name)",
    "  local obj={name=name, background='dark'}",
    "  setmetatable(obj,self)",
    "  self.__index=self",
    "  return obj",
    "end",
    "local ok,result=pcall(function() return ThemeConfig:new('example') end)",
    "if not ok then vim.api.nvim_err_writeln('Failed to create theme: '..result) end",
    "",
    "-- String manipulation & regex",
    "local message=[[This is a multi-line string\nwith various content types:\n- Numbers: 123,45.67,0xFF\n- Booleans: true,false\n- Special chars: @#$%^&*()[]{}]]",
    "local pattern='%w+%.%w+'",
    "local matches={}",
    "for m in message:gmatch(pattern) do table.insert(matches,m) end",
    "",
    "-- Complex syntax",
    "return setmetatable({",
    "  get_theme=function() return config.theme end,",
    "  set_theme=function(theme) config.theme=theme end,",
    "  __call=function(_,...) return setup_colorscheme(...) end",
    "},{__index=config,__newindex=function(t,k,v) rawset(config,k,v) end})"
  }

  return preview_state.sample_content
end

-- Create a buffer + window helper
local function create_preview_window(title, content)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  local width = math.min(80, vim.o.columns - 10)
  local height = math.min(#content + 4, vim.o.lines - 10)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center"
  })
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "lua")
  return buf, win
end

-- Keymap helper for preview windows
local function set_preview_keymaps(buf, close_fn, apply_fn)
  local opts = { noremap = true, silent = true, buffer = buf }
  map("n", "q", close_fn, opts)
  map("n", "<Esc>", close_fn, opts)
  if apply_fn then map("n", "<CR>", apply_fn, opts) end
end

-- Store original colorscheme if needed
local function store_original()
  if not preview_state.original_colorscheme then
    preview_state.original_colorscheme = loader.get_current_colorscheme()
  end
end

-- Close preview by ID
function M.close_preview(preview_id)
  local preview = preview_state.active_previews[preview_id]
  if not preview then return end
  if preview.win and vim.api.nvim_win_is_valid(preview.win) then vim.api.nvim_win_close(preview.win, true) end
  preview_state.active_previews[preview_id] = nil

  if vim.tbl_isempty(preview_state.active_previews) and preview_state.original_colorscheme then
    loader.apply_colorscheme(preview_state.original_colorscheme.name, preview_state.original_colorscheme.type)
    preview_state.original_colorscheme = nil
  end
end

-- Close all previews
function M.close_all_previews()
  for id, _ in pairs(preview_state.active_previews) do M.close_preview(id) end
end

-- Single colorscheme preview
function M.preview_colorscheme(name, scheme_type, duration)
  store_original()
  local success = loader.apply_colorscheme(name, scheme_type)
  if not success then
    vim.notify("Failed to preview colorscheme: " .. name, vim.log.levels.ERROR)
    return false
  end

  local buf, win = create_preview_window("Preview: " .. colors_config.get_display_name(name, scheme_type),
    get_sample_content())
  local preview_id = name .. "_" .. scheme_type
  preview_state.active_previews[preview_id] = { buf = buf, win = win, name = name, type = scheme_type }

  if duration and duration > 0 then
    vim.defer_fn(function() M.close_preview(preview_id) end, duration)
  end

  set_preview_keymaps(buf,
    function() M.close_preview(preview_id) end,
    function()
      loader.apply_colorscheme(name, scheme_type)
      M.close_all_previews()
      vim.notify("Applied colorscheme: " .. colors_config.get_display_name(name, scheme_type), vim.log.levels.INFO)
    end
  )

  vim.notify("Preview: " .. colors_config.get_display_name(name, scheme_type) .. " (q to close, Enter to apply)",
    vim.log.levels.INFO)
  return true
end

-- Quick preview
function M.quick_preview(name, scheme_type, timeout)
  timeout = timeout or 2000
  if preview_state.preview_timeout then vim.fn.timer_stop(preview_state.preview_timeout) end
  store_original()
  if loader.apply_colorscheme(name, scheme_type) then
    vim.notify("Quick preview: " .. colors_config.get_display_name(name, scheme_type), vim.log.levels.INFO)
    preview_state.preview_timeout = vim.defer_fn(function()
      if preview_state.original_colorscheme then
        loader.apply_colorscheme(preview_state.original_colorscheme.name, preview_state.original_colorscheme.type)
        preview_state.original_colorscheme = nil
      end
      preview_state.preview_timeout = nil
    end, timeout)
    return true
  end
  return false
end

function M.cancel_quick_preview()
  if preview_state.preview_timeout then
    vim.fn.timer_stop(preview_state.preview_timeout)
    preview_state.preview_timeout = nil
    preview_state.original_colorscheme = nil
    vim.notify("Quick preview cancelled", vim.log.levels.INFO)
  end
end

-- Get preview status
function M.get_preview_status()
  return {
    active_previews = vim.tbl_count(preview_state.active_previews),
    original_colorscheme = preview_state.original_colorscheme,
    has_quick_preview = preview_state.preview_timeout ~= nil
  }
end

-- Slideshow preview
function M.slideshow_preview(colorschemes, interval, loop)
  interval = interval or 3000
  loop = loop ~= false
  colorschemes = (colorschemes and #colorschemes > 0) and colorschemes or colors_config.get_all_colorschemes()
  store_original()

  local index = 1
  local timer = nil

  local function next_slide()
    if index <= #colorschemes then
      local cs = colorschemes[index]
      loader.apply_colorscheme(cs.name, cs.type)
      vim.notify("Slideshow: " .. colors_config.get_display_name(cs.name, cs.type) .. " (" .. index ..
      "/" .. #colorschemes .. ")", vim.log.levels.INFO)
      index = index + 1
      if index > #colorschemes and loop then index = 1 end
      if index <= #colorschemes or loop then
        timer = vim.defer_fn(next_slide, interval)
      else
        vim.notify("Slideshow completed", vim.log.levels.INFO)
        if preview_state.original_colorscheme then
          vim.defer_fn(function()
            loader.apply_colorscheme(preview_state.original_colorscheme.name, preview_state.original_colorscheme.type)
            preview_state.original_colorscheme = nil
          end, 1000)
        end
      end
    end
  end

  vim.notify("Starting slideshow with " .. #colorschemes .. " colorschemes", vim.log.levels.INFO)
  next_slide()

  return function()
    if timer then vim.fn.timer_stop(timer) end
    if preview_state.original_colorscheme then
      loader.apply_colorscheme(preview_state.original_colorscheme.name, preview_state.original_colorscheme.type)
      preview_state.original_colorscheme = nil
    end
    vim.notify("Slideshow stopped", vim.log.levels.INFO)
  end
end

return M
