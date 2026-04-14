local M = {}

local config = {
  enabled = true,
  filetype_overrides = {},
  disabled_filetypes = {},
  highlight_overrides = {},
}

local state = {
  enabled_bufs = {},
}

local commands_registered = false

local function apply_highlight_overrides()
  for token_type, hl in pairs(config.highlight_overrides) do
    local group = "@lsp.type." .. token_type
    if type(hl) == "string" then
      vim.api.nvim_set_hl(0, group, { link = hl })
    elseif type(hl) == "table" then
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

local function is_filetype_disabled(ft)
  for _, disabled_ft in ipairs(config.disabled_filetypes) do
    if ft == disabled_ft then
      return true
    end
  end
  return false
end

function M.enable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not config.enabled then
    return
  end
  local ft = vim.bo[bufnr].filetype

  if is_filetype_disabled(ft) then
    vim.notify("Semantic tokens disabled for filetype: " .. ft, vim.log.levels.INFO)
    return
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    local caps = client.server_capabilities
    if caps and caps.semanticTokensProvider then
      vim.lsp.semantic_tokens.start(bufnr, client.id)
      state.enabled_bufs[bufnr] = true
    end
  end
end

function M.disable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    pcall(vim.lsp.semantic_tokens.stop, bufnr, client.id)
  end
  state.enabled_bufs[bufnr] = nil
end

function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if state.enabled_bufs[bufnr] then
    M.disable(bufnr)
    vim.notify("Semantic tokens: OFF", vim.log.levels.INFO)
  else
    M.enable(bufnr)
    vim.notify("Semantic tokens: ON", vim.log.levels.INFO)
  end
end

function M.toggle_global()
  config.enabled = not config.enabled
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      if config.enabled then
        M.enable(buf)
      else
        M.disable(buf)
      end
    end
  end
  vim.notify("Semantic tokens global: " .. (config.enabled and "ON" or "OFF"), vim.log.levels.INFO)
end

function M.status(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return {
    global = config.enabled,
    buffer = state.enabled_bufs[bufnr] or false,
    filetype = vim.bo[bufnr].filetype,
    disabled_ft = is_filetype_disabled(vim.bo[bufnr].filetype),
  }
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  apply_highlight_overrides()

  if not commands_registered then
    vim.api.nvim_create_user_command("LspSemanticTokensToggle", function()
      M.toggle()
    end, { desc = "Toggle semantic tokens for the current buffer" })

    vim.api.nvim_create_user_command("LspSemanticTokensGlobal", function()
      M.toggle_global()
    end, { desc = "Toggle semantic tokens globally" })

    vim.api.nvim_create_user_command("LspSemanticTokensStatus", function()
      local status = M.status()
      vim.notify(
        string.format(
          "Semantic tokens: global=%s buffer=%s filetype=%s disabled_ft=%s",
          tostring(status.global),
          tostring(status.buffer),
          status.filetype,
          tostring(status.disabled_ft)
        ),
        vim.log.levels.INFO
      )
    end, { desc = "Show semantic token status" })

    commands_registered = true
  end

  if not config.enabled then
    return
  end

  local group = vim.api.nvim_create_augroup("LspSemanticTokens", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(ev)
      local ft = vim.bo[ev.buf].filetype
      if is_filetype_disabled(ft) then
        M.disable(ev.buf)
        return
      end
      -- apply filetype-specific overrides
      local ft_overrides = config.filetype_overrides[ft]
      if ft_overrides then
        for token_type, hl in pairs(ft_overrides) do
          local hl_group = "@lsp.type." .. token_type .. "." .. ft
          if type(hl) == "string" then
            vim.api.nvim_set_hl(0, hl_group, { link = hl })
          elseif type(hl) == "table" then
            vim.api.nvim_set_hl(0, hl_group, hl)
          end
        end
      end
      M.enable(ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(ev)
      state.enabled_bufs[ev.buf] = nil
    end,
  })
end

return M
