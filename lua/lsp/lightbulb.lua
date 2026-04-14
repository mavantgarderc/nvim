local M = {}

local ns = vim.api.nvim_create_namespace("lsp_lightbulb")
local sign_name = "LspLightbulb"
local debounce_timer = nil
local DEBOUNCE_MS = 150

vim.fn.sign_define(sign_name, { text = "💡", texthl = "DiagnosticSignWarn" })

local function update_lightbulb(bufnr)
  vim.fn.sign_unplace("lsp_lightbulb", { buffer = bufnr })

  local params = vim.lsp.util.make_range_params()
  params.context = { diagnostics = vim.diagnostic.get(bufnr, { lnum = params.range.start.line }) }

  vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, results, _)
    if err or not results or #results == 0 then
      return
    end
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    vim.fn.sign_place(0, "lsp_lightbulb", sign_name, bufnr, { lnum = lnum, priority = 10 })
  end)
end

function M.setup(opts)
  opts = opts or {}
  DEBOUNCE_MS = opts.debounce or DEBOUNCE_MS

  local group = vim.api.nvim_create_augroup("LspLightbulb", { clear = true })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = group,
    callback = function(ev)
      local bufnr = ev.buf
      if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" }) == 0 then
        return
      end
      if debounce_timer then
        debounce_timer:stop()
      end
      debounce_timer = vim.defer_fn(function()
        update_lightbulb(bufnr)
      end, DEBOUNCE_MS)
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
    group = group,
    callback = function(ev)
      vim.fn.sign_unplace("lsp_lightbulb", { buffer = ev.buf })
    end,
  })
end

function M.disable()
  pcall(vim.api.nvim_del_augroup_by_name, "LspLightbulb")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    vim.fn.sign_unplace("lsp_lightbulb", { buffer = buf })
  end
end

return M
