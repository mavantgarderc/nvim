local M = {}

local config = {
  direction = "incoming", -- "incoming" | "outgoing" | "both"
  max_depth = 4,
  border = "rounded",
}

local commands_registered = false

local function item_range(item)
  return item.selectionRange or item.range
end

local function item_key(item, direction)
  local range = item_range(item)
  if not range then
    return string.format("%s:%s:%s", direction, item.uri or "", item.name or "")
  end

  return string.format(
    "%s:%s:%d:%d:%s",
    direction,
    item.uri or "",
    range.start.line,
    range.start.character,
    item.name or ""
  )
end

local function collect_calls(item, direction, depth, max_depth, results, seen, callback)
  if depth > max_depth then
    callback()
    return
  end

  local current_key = item_key(item, direction)
  if seen[current_key] then
    callback()
    return
  end
  seen[current_key] = true

  local method = direction == "incoming"
      and "callHierarchy/incomingCalls"
    or "callHierarchy/outgoingCalls"

  vim.lsp.buf_request(0, method, { item = item }, function(err, calls, _)
    if err or not calls or #calls == 0 then
      callback()
      return
    end

    local pending = #calls
    local function finish()
      pending = pending - 1
      if pending == 0 then
        callback()
      end
    end

    for _, call in ipairs(calls) do
      local target = direction == "incoming" and call.from or call.to
      local target_key = target and item_key(target, direction) or nil
      local target_range = target and item_range(target) or nil

      if not target or not target_range or seen[target_key] then
        finish()
      else
        table.insert(results, {
          name = target.name,
          kind = target.kind,
          uri = target.uri,
          range = target.range,
          selectionRange = target_range,
          depth = depth,
          direction = direction,
        })

        collect_calls(target, direction, depth + 1, max_depth, results, seen, finish)
      end
    end
  end)
end

local function render_tree(results, title)
  if #results == 0 then
    vim.notify("No calls found", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, r in ipairs(results) do
    local indent = string.rep("  ", r.depth - 1)
    local fname = vim.uri_to_fname(r.uri)
    local lnum = r.selectionRange.start.line + 1
    table.insert(items, {
      filename = fname,
      lnum = lnum,
      col = r.selectionRange.start.character + 1,
      text = indent .. r.name,
    })
  end

  vim.fn.setqflist({}, " ", { title = title, items = items })
  vim.cmd("copen")
end

local function prepare_and_collect(direction)
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/prepareCallHierarchy", params, function(err, result, _)
    if err or not result or #result == 0 then
      vim.notify("Cannot prepare call hierarchy", vim.log.levels.WARN)
      return
    end

    local item = result[1]
    local results = {}
    collect_calls(item, direction, 1, config.max_depth, results, {}, function()
      render_tree(results, direction:sub(1, 1):upper() .. direction:sub(2) .. " Calls: " .. item.name)
    end)
  end)
end

function M.incoming()
  prepare_and_collect("incoming")
end

function M.outgoing()
  prepare_and_collect("outgoing")
end

function M.show()
  if config.direction == "both" then
    prepare_and_collect("incoming")
    vim.defer_fn(function()
      prepare_and_collect("outgoing")
    end, 200)
  else
    prepare_and_collect(config.direction)
  end
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  if commands_registered then
    return
  end

  vim.api.nvim_create_user_command("LspCallHierarchy", function()
    M.show()
  end, { desc = "Show call hierarchy" })

  vim.api.nvim_create_user_command("LspIncomingCalls", function()
    M.incoming()
  end, { desc = "Show incoming calls" })

  vim.api.nvim_create_user_command("LspOutgoingCalls", function()
    M.outgoing()
  end, { desc = "Show outgoing calls" })

  commands_registered = true
end

return M
