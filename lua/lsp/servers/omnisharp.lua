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
local inspect = vim.inspect
local tbl_deep_extend = vim.tbl_deep_extend
local defer_fn = vim.defer_fn

-- helper function: find project root
local function find_project_root(bufname)
  local patterns = { "*.sln", "*.csproj", "*.fsproj", "*.vbproj", "project.json", "omnisharp.json" }
  local result = fs.find(patterns, { upward = true, path = bufname })
  if result and result[1] then
    return fs.dirname(result[1])
  end
  return nil
end

-- helper function: get omnisharp command
local function get_omnisharp_cmd()
  local pid = tostring(fn.getpid())

  local omnisharp_paths = {
    "omnisharp",
    "OmniSharp",
    fn.stdpath("data") .. "/mason/bin/omnisharp",
    fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp",
    "/usr/local/bin/omnisharp",
    "/usr/bin/omnisharp",
    env.HOME .. "/.local/bin/omnisharp",
    env.HOME .. "/.dotnet/tools/omnisharp",
  }

  for _, path in ipairs(omnisharp_paths) do
    if fn.executable(path) == 1 then
      -- print("Found OmniSharp at: " .. path)
      return { path, "--languageserver", "--hostPID", pid }
    end
  end

  notify("OmniSharp executable not found. Install via: dotnet tool install -g omnisharp", log.levels.ERROR)
  return nil
end

function M.setup(capabilities)
  local lspconfig = require("lspconfig")
  local extended = require("omnisharp_extended")
  local cmd = get_omnisharp_cmd()
  if not cmd then return end

  -- print("Setting up OmniSharp with command: " .. inspect(cmd))

  lspconfig.omnisharp.setup({
    cmd = cmd,
    capabilities = tbl_deep_extend("force", capabilities or {}, extended.capabilities or {}),

    root_dir = function(fname)
      local primary_root = find_project_root(fname)
      if primary_root then
        -- print("Found project root: " .. primary_root)
        return primary_root
      end
      local fallback = lspconfig.util.root_pattern(
        "*.sln",
        "*.csproj",
        "*.fsproj",
        "*.vbproj",
        "project.json",
        "omnisharp.json"
      )(fname)
      if fallback then
        -- print("Using fallback root: " .. fallback)
      end
      return fallback
    end,

    filetypes = { "cs", "vb", "razor", "cshtml" },

    flags = {
      debounce_text_changes = 150,
    },

    on_init = function(client, initialize_result)
      -- print("OmniSharp initialized successfully")
      defer_fn(function()
        client.initialized = true
      end, 1000)
    end,

    on_exit = function(code, signal, client_id)
      if code ~= 0 then
        -- print("OmniSharp exited with code: " .. tostring(code))
      end
    end,

    init_options = {
      AutomaticWorkspaceInit = true,
      StartupTimeout = 30000,
    },

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
        MSBuildExtensionsPath = nil,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
        EnableDecompilationSupport = true,
        DocumentAnalysisTimeoutMs = 30000,
        LocationTimeout = 10000,
      },
      Sdk = {
        IncludePrereleases = true,
      },
      enableRoslynAnalyzers = true,
      enableEditorConfigSupport = true,
      enableMsBuildLoadProjectsOnDemand = false,
      waitForDebugger = false,
      loggingLevel = "information",
    },

    on_attach = function(client, bufnr)
      if client.server_capabilities.semanticTokensProvider then
        lsp.semantic_tokens.start(bufnr, client.id)
      end

      defer_fn(function()
        client.initialized = true
        print("OmniSharp fully ready for buffer " .. bufnr)
      end, 2000)
    end,

    handlers = extended.handlers,
  })
end

return M
