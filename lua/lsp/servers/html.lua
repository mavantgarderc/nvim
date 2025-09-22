local M = {}

function M.setup(capabilities)
  vim.lsp.config("html", {
    capabilities = capabilities,
    filetypes = { "html", "templ" },
    settings = {
      html = {
        format = {
          templating = true,
          wrapLineLength = 120,
          wrapAttributes = "auto",
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  })
end

return M
