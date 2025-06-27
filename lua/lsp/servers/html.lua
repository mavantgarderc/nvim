local M = {}

function M.setup(capabilities)
    local lspconfig = require("lspconfig")

    lspconfig.html.setup({
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
