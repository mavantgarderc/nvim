local uv = vim.loop
local util = require("Raphael.util")

local M = {}

local state_file = vim.fn.stdpath("data") .. "/raphael/state.json"

local function ensure_dir()
  local dir = vim.fn.fnamemodify(state_file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

function M.load_state(state)
  ensure_dir()
  local fd = io.open(state_file, "r")
  if not fd then return end
  local content = fd:read("*a")
  fd:close()
  local ok, decoded = pcall(vim.fn.json_decode, content)
  if ok and type(decoded) == "table" then
    for k, v in pairs(decoded) do
      state[k] = v
    end
  end
end

function M.save_state(state)
  ensure_dir()
  local payload = vim.fn.json_encode(state)
  uv.fs_open(state_file, "w", 438, function(err, fd)
    if err then return end
    uv.fs_write(fd, payload, -1, function()
      uv.fs_close(fd)
    end)
  end)
end

function M.add_history(theme, state)
  table.insert(state.history, 1, theme)
  if #state.history > 5 then
    table.remove(state.history)
  end
end

function M.toggle_bookmark(theme, state)
  local idx = vim.fn.index(state.bookmarks, theme)
  if idx >= 0 then
    table.remove(state.bookmarks, idx + 1)
    vim.notify("Raphael: removed bookmark " .. theme)
  else
    table.insert(state.bookmarks, theme)
    vim.notify("Raphael: bookmarked " .. theme)
  end
  M.save_state(state)
end

return M
