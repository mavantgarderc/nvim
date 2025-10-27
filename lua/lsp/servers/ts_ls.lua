if #vim.api.nvim_list_uis() == 0 then return { setup = function() end } end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      vim.notify("[lsp.servers.typescript] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local config_ok = pcall(require, "lspconfig.server_configurations.ts_ls")
    if not config_ok then
      vim.notify("[lsp.servers.typescript] ts_ls configuration not available", vim.log.levels.WARN)
      return
    end

    local setup_ok, err = pcall(function()
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = function(client) client.server_capabilities.documentFormattingProvider = false end,
      })
    end)

    if not setup_ok then vim.notify("[lsp.servers.typescript] Setup failed: " .. tostring(err), vim.log.levels.WARN) end

    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    }
  end, 100)
end

return M
