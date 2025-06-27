local M = {}

function M.setup(capabilities)
    local lspconfig = require("lspconfig")

    lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                },
            },
        },
    })
end

return M
