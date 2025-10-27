if #vim.api.nvim_list_uis() == 0 then
  return { setup = function() end }
end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local vimtex_ok, lspconfig = pcall(require, "lspconfig")
    if not vimtex_ok then
      vim.notify("[lsp.servers.texlab] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local vimtext_config_ok = pcall(require, "lspconfig.server_configurations.texlab")
    if not vimtext_config_ok then
      vim.notify("[lsp.servers.texlab] texlab configuration not available", vim.log.levels.WARN)
      return
    end

    local vimtex_setup_ok, err = pcall(function()
      lspconfig.texlab.setup({
        capabilities = capabilities,
        settings = {
          texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              executable = "latexmk",
              forwardSearchAfter = false,
              onSave = false,
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
              executable = "zathura",
              args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false,
            },
          },
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
    end)

    if not vimtex_setup_ok then
      vim.notify("[lsp.servers.texlab] Setup failed: " .. tostring(err), vim.log.levels.WARN)
    end
  end, 100)
end

return M
