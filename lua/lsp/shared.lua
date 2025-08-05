local M = {}

local map = vim.keymap.set
local api = vim.api
local buf = vim.lsp.buf
local diagnostic = vim.diagnostic
local g = vim.g
local fn = vim.fn
local notify = vim.notify
local inspect = vim.inspect
local b = vim.b
local lsp = vim.lsp
local log = vim.log
local defer_fn = vim.defer_fn
local uri_from_bufnr = vim.uri_from_bufnr
local split = vim.split
local tbl_isempty = vim.tbl_isempty

function M.setup_keymaps()
  local keymaps_ok, keymaps = pcall(require, "core.keymaps.lsp")
  if keymaps_ok and keymaps.setup_lsp_keymaps then
    keymaps.setup_lsp_keymaps()

    -- print("Warning: core.keymaps.lsp not found, skipping keymap setup")
  end
end

function M.setup_diagnostics()
  diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    float = {
      border = "rounded",
      source = "if_many",
      header = "",
      prefix = "",
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    },
    underline = {
      severity = { diagnostic.severity.ERROR, diagnostic.severity.WARN },
    },
    signs = g.have_nerd_font and {
      text = {
        [diagnostic.severity.ERROR] = "󰅚",
        [diagnostic.severity.WARN] = "󰀪",
        [diagnostic.severity.INFO] = "󰋽",
        [diagnostic.severity.HINT] = "󰌶",
      },
      linehl = { [diagnostic.severity.ERROR] = "DiagnosticSignError" },
      numhl = { [diagnostic.severity.ERROR] = "DiagnosticSignError" },
    } or {},
    virtual_text = {
      source = "if_many",
      spacing = 4,
      prefix = "●",
      severity = { min = diagnostic.severity.WARN },
      format = function(diagnostic)
        local message = diagnostic.message
        if #message > 80 then message = message:sub(1, 77) .. "..." end
        return message
      end,
    },
  })

  if g.have_nerd_font then
    local signs = {
      { name = "DiagnosticSignError", text = "󰅚", texthl = "DiagnosticSignError" },
      { name = "DiagnosticSignWarn", text = "󰀪", texthl = "DiagnosticSignWarn" },
      { name = "DiagnosticSignInfo", text = "󰋽", texthl = "DiagnosticSignInfo" },
      { name = "DiagnosticSignHint", text = "󰌶", texthl = "DiagnosticSignHint" },
    }

    for _, sign in ipairs(signs) do
      fn.sign_define(sign.name, sign)
    end
  end
end

function M.setup_completion(cmp, luasnip) return end

function M.get_capabilities()
  local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities

  if cmp_ok and cmp_nvim_lsp.default_capabilities then
    capabilities = cmp_nvim_lsp.default_capabilities()
    -- print("✓ Using cmp_nvim_lsp capabilities")
  else
    capabilities = lsp.protocol.make_client_capabilities()
    -- print("⚠ cmp_nvim_lsp not found, using default capabilities")
  end

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return capabilities
end

function M.setup_null_ls()
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  if not null_ls_ok then
    print("null-ls not found, skipping setup")
    return
  end

  local sources = {}

  if fn.executable("stylua") == 1 then table.insert(sources, null_ls.builtins.formatting.stylua) end

  if fn.executable("csharpier") == 1 then table.insert(sources, null_ls.builtins.formatting.csharpier) end

  if fn.executable("sql-formatter") == 1 then table.insert(sources, null_ls.builtins.formatting.sql_formatter) end

  if fn.executable("sqlfluff") == 1 then
    table.insert(sources, null_ls.builtins.formatting.sqlfluff)
    table.insert(
      sources,
      null_ls.builtins.diagnostics.sqlfluff.with({
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        disabled_filetypes = {},
      })
    )
  end

  if fn.executable("prettier") == 1 then table.insert(sources, null_ls.builtins.formatting.prettier) end

  if fn.executable("black") == 1 then table.insert(sources, null_ls.builtins.formatting.black) end

  if fn.executable("isort") == 1 then table.insert(sources, null_ls.builtins.formatting.isort) end

  null_ls.setup({
    sources = sources,
    diagnostics_format = "#{m}",
    update_in_insert = false,
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            if b.lsp_format_on_save ~= false then
              lsp.buf.format({
                bufnr = bufnr,
                filter = function(c) return c.name == "null-ls" end,
              })
            end
          end,
        })
      end
    end,
  })
end

function M.setup_format_keymap()
  map("n", "<leader>gf", function()
    buf.format({
      async = true,
      filter = function(client) return client.name ~= "ts_ls" end,
    })
  end, { desc = "Format with LSP/null-ls" })

  map("x", "<leader>gf", function()
    buf.format({
      async = true,
      range = {
        start = fn.getpos("'<"),
        ["end"] = fn.getpos("'>"),
      },
      filter = function(client) return client.name ~= "ts_ls" end,
    })
  end, { desc = "Format selection" })
end

function M.setup_autoformat()
  api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      if b.lsp_format_on_save ~= false then
        buf.format({
          async = false,
          filter = function(client) return client.name ~= "ts_ls" end,
        })
      end
    end,
  })
end

-- LSP UI
function M.setup_lsp_ui()
  lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
    config = config or {}
    config.border = config.border or "rounded"
    config.title = config.title or "Hover"

    if not result or not result.contents then return end

    local markdown_lines = lsp.util.convert_input_to_markdown_lines(result.contents)
    local content = table.concat(markdown_lines, "\n")
    markdown_lines = split(content, "\n", { trimempty = true })

    if tbl_isempty(markdown_lines) then return end

    return lsp.util.open_floating_preview(markdown_lines, "markdown", config)
  end

  lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
    config = config or {}
    config.border = config.border or "rounded"
    config.title = config.title or "Signature Help"

    if not result or not result.signatures or tbl_isempty(result.signatures) then return end

    local lines = {}
    for i, signature in ipairs(result.signatures) do
      table.insert(lines, signature.label)
      if signature.documentation then
        table.insert(lines, "")
        if type(signature.documentation) == "string" then
          table.insert(lines, signature.documentation)
        elseif signature.documentation.value then
          table.insert(lines, signature.documentation.value)
        end
      end
      if i < #result.signatures then table.insert(lines, "") end
    end

    return lsp.util.open_floating_preview(lines, "markdown", config)
  end

  local progress_handler = function(_, result, ctx)
    local client = lsp.get_client_by_id(ctx.client_id)
    if not client then return end

    local value = result.value
    if value.kind == "end" then
      notify(string.format("%s: %s", client.name, value.message or "Complete"), log.levels.INFO)
    elseif value.kind == "report" and value.message then
      local percentage = value.percentage and string.format(" (%.0f%%)", value.percentage) or ""
      notify(string.format("%s: %s%s", client.name, value.message, percentage), log.levels.INFO)
    end
  end

  lsp.handlers["$/progress"] = progress_handler
end

return M
