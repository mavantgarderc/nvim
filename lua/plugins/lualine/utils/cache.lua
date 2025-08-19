local loop = vim.loop

local M = {}

M.cache = {
  lsp_clients = { value = "", last_update = 0 },
  python_env = { value = "", last_update = 0 },
  dotnet_project = { value = "", last_update = 0 },
  test_status = { value = "", last_update = 0 },
  debug_status = { value = "", last_update = 0 },
  current_symbol = { value = "", last_update = 0 },
}

function M.get_cached_value(key, update_fn, ttl)
  ttl = ttl or 500
  local now = loop.hrtime() / 1000000
  local cached = M.cache[key]

  if not cached or (now - cached.last_update) > ttl then
    cached.value = update_fn()
    cached.last_update = now
    M.cache[key] = cached
  end
  return cached.value
end

return M
