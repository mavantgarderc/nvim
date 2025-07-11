local M = {}

local fn = vim.fn
local api = vim.api
local fs = vim.fs
local env = vim.env
local log = vim.log
local notify = vim.notify
local lsp = vim.lsp
local map = vim.keymap.set
local tbl_extend = vim.tbl_extend
local islist = vim.islist
local diagnostic = vim.diagnostic

-- helper function to find project root
local function find_project_root(bufname)
    local patterns = { "*.sln", "*.csproj", "*.fsproj", "*.vbproj", "project.json", "omnisharp.json" }
    local result = fs.find(patterns, { upward = true, path = bufname })
    if result and result[1] then
        return fs.dirname(result[1])
    end
    return nil
end

-- helper function to get omnisharp command
local function get_omnisharp_cmd()
    local pid = tostring(fn.getpid())

    -- check for different OmniSharp installations
    if fn.executable("omnisharp") == 1 then
        return { "omnisharp", "--languageserver", "--hostPID", pid }
    elseif fn.executable("OmniSharp") == 1 then
        return { "OmniSharp", "--languageserver", "--hostPID", pid }
    else
        -- fallback to common installation paths
        local omnisharp_paths = {
            fn.stdpath("data") .. "/mason/bin/omnisharp",
            "/usr/local/bin/omnisharp",
            env.HOME .. "/.local/bin/omnisharp",
        }

        for _, path in ipairs(omnisharp_paths) do
            if fn.executable(path) == 1 then return { path, "--languageserver", "--hostPID", pid } end
        end
    end

    notify("OmniSharp executable not found", log.levels.ERROR)
    return nil
end

function M.setup(capabilities)
    local lspconfig = require("lspconfig")
    local cmd = get_omnisharp_cmd()
    if not cmd then return end

    lspconfig.omnisharp.setup({
        cmd = cmd,
        capabilities = capabilities,

        -- enhanced root directory detection
        root_dir = function(fname)
            local primary_root = find_project_root(fname)
            if primary_root then return primary_root end
            -- fallback to lspconfig's default
            return lspconfig.util.root_pattern(
                "*.sln",
                "*.csproj",
                "*.fsproj",
                "*.vbproj",
                "project.json",
                "omnisharp.json"
            )(fname)
        end,

        -- file types to attach to
        filetypes = { "cs", "vb" },

        settings = {
            FormattingOptions = {
                EnableEditorConfigSupport = true,
                OrganizeImports = true,
                NewLine = "\n",
                UseTabs = false,
                TabSize = 4,
                IndentationSize = 4,
                SpacingAfterMethodDeclarationName = false,
                SpaceWithinMethodDeclarationParenthesis = false,
                SpaceBetweenEmptyMethodDeclarationParentheses = false,
                SpaceAfterMethodCallName = false,
                SpaceWithinMethodCallParentheses = false,
                SpaceBetweenEmptyMethodCallParentheses = false,
                SpaceAfterControlFlowStatementKeyword = true,
                SpaceWithinExpressionParentheses = false,
                SpaceWithinCastParentheses = false,
                SpaceWithinOtherParentheses = false,
                SpaceAfterCast = false,
                SpacesIgnoreAroundVariableDeclaration = false,
                SpaceBeforeOpenSquareBracket = false,
                SpaceBetweenEmptySquareBrackets = false,
                SpaceWithinSquareBrackets = false,
                SpaceAfterColonInBaseTypeDeclaration = true,
                SpaceAfterComma = true,
                SpaceAfterDot = false,
                SpaceAfterSemicolonsInForStatement = true,
                SpaceBeforeColonInBaseTypeDeclaration = true,
                SpaceBeforeComma = false,
                SpaceBeforeDot = false,
                SpaceBeforeSemicolonsInForStatement = false,
                SpacingAroundBinaryOperator = "single",
                WrappingPreserveSingleLine = true,
                WrappingKeepStatementsOnSingleLine = true,
            },
            MsBuild = {
                LoadProjectsOnDemand = false,
            },
            RoslynExtensionsOptions = {
                EnableAnalyzersSupport = true,
                EnableImportCompletion = true,
                EnableDecompilationSupport = true,
                DocumentAnalysisTimeoutMs = 30000,
            },
            Sdk = {
                IncludePrereleases = true,
            },
        },

        init_options = {
            AutomaticWorkspaceInit = true,
        },

        -- on_attach function
        on_attach = function(client, bufnr)
            -- Enable semantic highlighting if supported
            if client.server_capabilities.semanticTokensProvider then
                lsp.semantic_tokens.start(bufnr, client.id)
            end

            -- set up buffer-local keymaps specific to C#
            local opts = { buffer = bufnr, silent = true }

            ---@diagnostic disable-next-line: param-type-mismatch
            map( "n", "<leader>cu", function() lsp.buf.code_action({
                context = {
                    only = { "source.addMissingImports" },
                    diagnostics = diagnostic.get(bufnr)
                }, apply = true, })
            end, tbl_extend("force", opts, { desc = "Add missing usings" }))

            ---@diagnostic disable-next-line: param-type-mismatch
            map( "n", "<leader>co", function() lsp.buf.code_action({
                context = {
                    only = { "source.organizeImports" },
                    diagnostics = diagnostic.get(bufnr)
                }, apply = true })
            end, tbl_extend("force", opts, { desc = "Organize imports" }))

            ---@diagnostic disable-next-line: param-type-mismatch
            map( "n", "<leader>cr", function() lsp.buf.code_action({
                context = {
                    only = { "source.removeUnnecessaryImports" },
                    diagnostics = diagnostic.get(bufnr)
                }, apply = true, })
            end, tbl_extend("force", opts, { desc = "Remove unnecessary usings" }))

            -- dap integration
            if fn.executable("netcoredbg") == 1 then
                ---@diagnostic disable-next-line: param-type-mismatch
                map( "n", "<leader>rt", function() lsp.buf.code_action({
                    context = {
                        only = { "source.runTest" },
                        diagnostics = diagnostic.get(bufnr)
                    }, apply = true, })
                end, tbl_extend("force", opts, { desc = "Run test" }))

                ---@diagnostic disable-next-line: param-type-mismatch
                map( "n", "<leader>dt", function() lsp.buf.code_action({
                    context = {
                        only = { "source.debugTest" },
                        diagnostics = diagnostic.get(bufnr)
                    }, apply = true, })
                end, tbl_extend("force", opts, { desc = "Debug test" }))
            end
        end,

        -- handler overrides for better formatting
        handlers = {
            ["textDocument/definition"] = function(err, result, method, ...)
                if islist(result) and #result > 1 then
                    local filtered_result = {}
                    for _, res in ipairs(result) do
                        if not string.match(res.uri, "metadata") then table.insert(filtered_result, res) end
                    end
                    if #filtered_result > 0 then result = filtered_result end
                end
                lsp.handlers["textDocument/definition"](err, result, method, ...)
            end,
        },

        -- flags for better performance
        flags = {
            debounce_text_changes = 150,
        },
    })
end

return M
