-- TTL-based cache system for components

local loop = vim.loop

local cache = {}

local M = {}

function M.get(key, update_fn, ttl)
  ttl = ttl or 500
  local now = loop.hrtime() / 1000000
  local entry = cache[key] or { value = "", last_update = 0 }

  if (now - entry.last_update) > ttl then
    entry.value = update_fn()
    entry.last_update = now
    cache[key] = entry
  end
  return entry.value
end

function M.invalidate(key)
  cache[key] = { value = "", last_update = 0 }
end

return M
