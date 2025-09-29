local M = {}

local map = vim.keymap.set
local diagnostic = vim.diagnostic

function M.setup_keymaps()
  local ok, keymaps = pcall(require, "core.keymaps.lsp")
  if ok and keymaps.setup_lsp_keymaps then
    keymaps.setup_lsp_keymaps()
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
    signs = vim.g.have_nerd_font and {
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
      format = function(d)
        local msg = d.message
        if #msg > 80 then msg = msg:sub(1, 77) .. "..." end
        return msg
      end,
    },
  })

  if vim.g.have_nerd_font then
    local signs = {
      { name = "DiagnosticSignError", text = "󰅚", texthl = "DiagnosticSignError" },
      { name = "DiagnosticSignWarn", text = "󰀪", texthl = "DiagnosticSignWarn" },
      { name = "DiagnosticSignInfo", text = "󰋽", texthl = "DiagnosticSignInfo" },
      { name = "DiagnosticSignHint", text = "󰌶", texthl = "DiagnosticSignHint" },
    }
    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, sign)
    end
  end
end

function M.get_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local caps = ok and cmp_nvim_lsp.default_capabilities()
      or vim.lsp.protocol.make_client_capabilities()

  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  caps.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return caps
end

function M.setup_null_ls()
  local ok, null_ls = pcall(require, "null-ls")
  if not ok then
    print("null-ls not found, skipping setup")
    return
  end

  local sources = {}

  if vim.fn.executable("stylua") == 1 then
    table.insert(sources, null_ls.builtins.formatting.stylua.with({
      extra_args = { "--config-path", "/home/mava/.config/stylua/stylua.toml" },
    }))
  end

  if vim.fn.executable("csharpier") == 1 then
    table.insert(sources, null_ls.builtins.formatting.csharpier)
  end

  if vim.fn.executable("sql-formatter") == 1 then
    table.insert(sources, null_ls.builtins.formatting.sql_formatter)
  end
  if vim.fn.executable("sqlfluff") == 1 then
    table.insert(sources, null_ls.builtins.formatting.sqlfluff)
    table.insert(sources, null_ls.builtins.diagnostics.sqlfluff.with({
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    }))
  end

  if vim.fn.executable("prettier") == 1 then
    table.insert(sources, null_ls.builtins.formatting.prettier)
  end
  if vim.fn.executable("black") == 1 then
    table.insert(sources, null_ls.builtins.formatting.black)
  end
  if vim.fn.executable("isort") == 1 then
    table.insert(sources, null_ls.builtins.formatting.isort)
  end

  null_ls.setup({
    sources = sources,
    diagnostics_format = "#{m}",
    update_in_insert = false,
    on_attach = function(client, bufnr)
      if client:supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            if vim.b.lsp_format_on_save ~= false then
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c)
                  return c.name == "null-ls"
                end,
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
    vim.lsp.buf.format({
      async = true,
      filter = function(client)
        return client.name ~= "omnisharp"
      end,
    })
  end, { desc = "Format with LSP/null-ls" })

  map("x", "<leader>gf", function()
    vim.lsp.buf.format({
      async = true,
      range = { start = vim.fn.getpos("'<"), ["end"] = vim.fn.getpos("'>") },
      filter = function(client)
        return client.name ~= "omnisharp"
      end,
    })
  end, { desc = "Format selection" })
end

function M.setup_autoformat()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      if vim.b.lsp_format_on_save ~= false then
        vim.lsp.buf.format({
          async = false,
          filter = function(client)
            return client.name ~= "omnisharp"
          end,
        })
      end
    end,
  })
end

function M.setup_lsp_ui()
  vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
    config = config or {}
    config.border = config.border or "rounded"
    if not result or not result.contents then return end
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    local content = table.concat(markdown_lines, "\n")
    markdown_lines = vim.split(content, "\n", { trimempty = true })
    if vim.tbl_isempty(markdown_lines) then return end
    return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
  end

  vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
    config = config or {}
    config.border = config.border or "rounded"
    if not result or not result.signatures or vim.tbl_isempty(result.signatures) then return end
    local lines = {}
    for i, sig in ipairs(result.signatures) do
      table.insert(lines, sig.label)
      if sig.documentation then
        table.insert(lines, "")
        if type(sig.documentation) == "string" then
          table.insert(lines, sig.documentation)
        elseif sig.documentation.value then
          table.insert(lines, sig.documentation.value)
        end
      end
      if i < #result.signatures then table.insert(lines, "") end
    end
    return vim.lsp.util.open_floating_preview(lines, "markdown", config)
  end

  vim.lsp.handlers["$/progress"] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    local value = result.value
    if value.kind == "end" then
      vim.notify(string.format("%s: %s", client.name, value.message or "Complete"), vim.log.levels.INFO)
    elseif value.kind == "report" and value.message then
      local pct = value.percentage and string.format(" (%.0f%%)", value.percentage) or ""
      vim.notify(string.format("%s: %s%s", client.name, value.message, pct), vim.log.levels.INFO)
    end
  end
end

return M
