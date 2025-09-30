-- lua/Raphael/init.lua
-- Core for Raphael: state, persistence, safe loading order.

local Raphael = {}

local default_theme = "kanagawa-wave"

-- defaults
Raphael.state = {
  current = default_theme,
  previous = nil,
  auto_apply = false,
  bookmarks = {},
  collapsed = {}, -- persisted collapsed groups
}

Raphael.config = {
  leader = "<leader>t",
  mappings = { picker = "p", next = "n", previous = "N", random = "r" },
}

local state_file = vim.fn.stdpath("data") .. "/raphael/state.json"

-- async write helper
local function async_write(path, contents)
  vim.loop.fs_open(path, "w", 438, function(err, fd)
    if err then
      vim.schedule(function() vim.notify("Raphael: failed to write state: " .. tostring(err), vim.log.levels.WARN) end)
      return
    end
    vim.loop.fs_write(fd, contents, -1, function(write_err)
      if write_err and write_err ~= 0 then
        vim.schedule(function() vim.notify("Raphael: failed to write state (write): " .. tostring(write_err), vim.log.levels.WARN) end)
      end
      vim.loop.fs_close(fd)
    end)
  end)
end

-- load state (merges with defaults)
function Raphael.load_state()
  -- ensure directory exists
  local d = vim.fn.fnamemodify(state_file, ":h")
  if vim.fn.isdirectory(d) == 0 then vim.fn.mkdir(d, "p") end

  local f = io.open(state_file, "r")
  if not f then
    -- write defaults async
    local payload = vim.fn.json_encode(Raphael.state)
    async_write(state_file, payload)
    return
  end

  local content = f:read("*a")
  f:close()

  local ok, decoded = pcall(vim.fn.json_decode, content)
  if not ok or type(decoded) ~= "table" then
    -- overwrite with defaults
    local payload = vim.fn.json_encode(Raphael.state)
    async_write(state_file, payload)
    return
  end

  -- merge fields
  for k, v in pairs(decoded) do
    Raphael.state[k] = v
  end
end

-- save state (non-blocking)
function Raphael.save_state()
  local payload = vim.fn.json_encode(Raphael.state)
  async_write(state_file, payload)
end

-- safe requires & load order (no circular require)
Raphael.colors = require("Raphael.colors")
Raphael.themes = require("Raphael.themes")
Raphael.themes.refresh() -- detect installed colorschemes
-- load persisted state (after themes.refresh is available)
Raphael.load_state()

-- set vim.g flag for auto_apply (useful elsewhere)
vim.g.raphael_auto_theme = Raphael.state.auto_apply == true

-- require picker after themes.refresh and state load
Raphael.picker = require("Raphael.picker")

-- apply a theme and persist
function Raphael.apply(theme)
  if not theme or not Raphael.themes.is_available(theme) then
    vim.notify("Raphael: theme not available: " .. tostring(theme), vim.log.levels.WARN)
    return
  end
  Raphael.state.previous = Raphael.state.current
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if not ok then
    vim.notify("Raphael: failed to apply theme '" .. tostring(theme) .. "': " .. tostring(err), vim.log.levels.ERROR)
    -- fallback to default if available
    if Raphael.themes.is_available(default_theme) then
      pcall(vim.cmd.colorscheme, default_theme)
      Raphael.state.current = default_theme
    end
    Raphael.save_state()
    return
  end
  Raphael.state.current = theme
  -- persist
  Raphael.save_state()
  vim.notify("Raphael: applied " .. theme)
end

-- toggle auto-theme and persist
function Raphael.toggle_auto()
  Raphael.state.auto_apply = not Raphael.state.auto_apply
  vim.g.raphael_auto_theme = Raphael.state.auto_apply
  Raphael.save_state()
  vim.notify(Raphael.state.auto_apply and "Raphael auto-theme: ON" or "Raphael auto-theme: OFF")
end

-- bookmark toggle (persisted)
function Raphael.toggle_bookmark(theme)
  if not theme or theme == "" then return end
  local idx = vim.fn.index(Raphael.state.bookmarks or {}, theme)
  if idx >= 0 then
    table.remove(Raphael.state.bookmarks, idx + 1)
    vim.notify("Raphael: removed bookmark " .. theme)
  else
    table.insert(Raphael.state.bookmarks, theme)
    vim.notify("Raphael: bookmarked " .. theme)
  end
  Raphael.save_state()
end

-- open picker
function Raphael.open_picker()
  Raphael.picker.open(Raphael)
end

-- FileType autocmd: dynamic switching when auto_apply is on
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if not Raphael.state.auto_apply then return end
    local ft = args.match
    local theme = Raphael.themes.filetype_themes[ft]
    if theme and Raphael.themes.is_available(theme) then
      Raphael.apply(theme)
    end
  end,
})

-- keymaps (picker + toggle)
vim.keymap.set("n", Raphael.config.leader .. Raphael.config.mappings.picker, function() Raphael.open_picker() end, { desc = "Raphael: theme picker" })
vim.keymap.set("n", Raphael.config.leader .. "ta", function() Raphael.toggle_auto() end, { desc = "Raphael: toggle auto-theme" })

-- apply the saved current theme on startup (scheduled)
vim.schedule(function()
  if Raphael.themes.is_available(Raphael.state.current) then
    pcall(vim.cmd.colorscheme, Raphael.state.current)
  else
    if Raphael.themes.is_available(default_theme) then
      pcall(vim.cmd.colorscheme, default_theme)
      Raphael.state.current = default_theme
      Raphael.save_state()
    else
      vim.notify("Raphael: fallback theme not found", vim.log.levels.WARN)
    end
  end
end)

return Raphael
