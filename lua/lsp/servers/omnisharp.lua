local M = {}

local fn = vim.fn

function M.setup(capabilities)
    local lspconfig = require("lspconfig")

    lspconfig.omnisharp.setup({
        cmd = {
            "omnisharp",
            "--languageserver",
            "--hostPID",
            tostring(fn.getpid()),
        },
        capabilities = capabilities,
        settings = {
            FormattingOptions = {
                EnableEditorConfigSupport = true,
                OrganizeImports = true,
            },
            MsBuild = {
                LoadProjectsOnDemand = false,
            },
            RoslynExtensionsOptions = {
                EnableAnalyzersSupport = true,
                EnableImportCompletion = true,
            },
        },
    })
end

return M
