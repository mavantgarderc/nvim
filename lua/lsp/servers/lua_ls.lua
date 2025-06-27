local M = {}

local fn = vim.fn

function M.setup(capabilities)
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        [fn.expand("$VIMRUNTIME/lua")] = true,
                        [fn.stdpath("config") .. "/lua"] = true,
                    },
                },
            },
        },
    })
end

return M
