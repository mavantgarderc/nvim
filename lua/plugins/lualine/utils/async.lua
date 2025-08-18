-- Async helpers (timers, defer, schedule)
-- Centralized place for all async/event logic

local loop = vim.loop

local M = {}

function M.defer(fn, ms)
  vim.defer_fn(fn, ms)
end

function M.schedule(fn)
  return vim.schedule_wrap(fn)
end

function M.set_interval(interval, callback)
  local timer = loop.new_timer()
  if timer then
    timer:start(interval, interval, M.schedule(callback))
  end
  return timer
end

function M.set_timeout(delay, callback)
  local timer = loop.new_timer()
  if timer then
    timer:start(delay, 0, M.schedule(function()
      callback()
      timer:stop()
      timer:close()
    end))
  end
  return timer
end

return M
