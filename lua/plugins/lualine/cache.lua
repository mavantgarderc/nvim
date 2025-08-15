local loop = vim.loop

local M = {
  store = {
    lsp_clients    = { value = "", last_update = 0 },
    python_env     = { value = "", last_update = 0 },
    dotnet_project = { value = "", last_update = 0 },
    test_status    = { value = "", last_update = 0 },
    debug_status   = { value = "", last_update = 0 },
    current_symbol = { value = "", last_update = 0 },
  }
}

function M.get(key, update_fn, ttl)
  ttl = ttl or 500
  local now = loop.hrtime() / 1e6
  local cached = M.store[key]

  if not cached or (now - cached.last_update) > ttl then
    cached.value = update_fn()
    cached.last_update = now
    M.store[key] = cached
  end
  return cached.value
end

function M.invalidate(keys)
  for _, key in ipairs(keys) do
    M.store[key] = { value = "", last_update = 0 }
  end
end

return M
