local M = {}

local config = {
  fallback_to_references = true,
  open_strategy = "quickfix", -- "quickfix" | "telescope" | "float"
  cross_package = true,
}

local commands_registered = false

local function show_results(results, title)
  if config.open_strategy == "telescope" then
    local pickers_ok, _ = pcall(require, "telescope.builtin")
    if pickers_ok then
      vim.lsp.buf.implementation()
      return
    end
  end

  local items = vim.lsp.util.locations_to_items(results, "utf-8")
  if #items == 0 then
    vim.notify("No implementations found", vim.log.levels.INFO)
    return
  end

  if #items == 1 then
    local item = items[1]
    vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
    vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
    return
  end

  vim.fn.setqflist({}, " ", { title = title, items = items })
  vim.cmd("copen")
end

local function try_references(params, bufnr)
  params.context = { includeDeclaration = false }
  vim.lsp.buf_request(bufnr, "textDocument/references", params, function(err, result, _)
    if err or not result or #result == 0 then
      vim.notify("No implementations or references found", vim.log.levels.INFO)
      return
    end
    show_results(result, "References (fallback)")
  end)
end

function M.find(opts)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params()

  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/implementation" })

  if #clients == 0 then
    if config.fallback_to_references then
      try_references(params, bufnr)
    else
      vim.notify("No LSP client supports implementation", vim.log.levels.WARN)
    end
    return
  end

  vim.lsp.buf_request(bufnr, "textDocument/implementation", params, function(err, result, _)
    if err then
      vim.notify("Implementation: " .. tostring(err.message), vim.log.levels.ERROR)
      return
    end

    if not result or #result == 0 then
      if config.fallback_to_references then
        try_references(params, bufnr)
      else
        vim.notify("No implementations found", vim.log.levels.INFO)
      end
      return
    end

    show_results(result, "Implementations")
  end)
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  if commands_registered then
    return
  end

  vim.api.nvim_create_user_command("LspImplementation", function()
    M.find()
  end, { desc = "Jump to LSP implementations" })

  commands_registered = true
end

return M
