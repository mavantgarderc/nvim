local M = {}

local fn = vim.fn
local fs = vim.fs
local env = vim.fn
local log = vim.log
local notify = vim.notify
local lsp = vim.lsp
local defer_fn, tbl_deep_extend = vim.defer_fn, vim.tbl_deep_extend

-- helper: find project root
local function find_project_root(bufname)
  local patterns = { "*.sln", "*.csproj", "*.fsproj", "*.vbproj", "project.json", "omnisharp.json" }
  local result = fs.find(patterns, { upward = true, path = bufname })
  if result and result[1] then
    return fs.dirname(result[1])
  end
  return nil
end

-- helper: get omnisharp command
local function get_omnisharp_cmd()
  local fn = vim.fn
  local notify = vim.notify
  local log = vim.log

  local pid = tostring(fn.getpid())
  local home = os.getenv("HOME")
  local candidates = {
    "omnisharp",
    "OmniSharp",
    fn.stdpath("data") .. "/mason/bin/omnisharp",
    fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp",
    "/usr/local/bin/omnisharp",
    "/usr/bin/omnisharp",
    home .. "/.local/bin/omnisharp",
    home .. "/.dotnet/tools/omnisharp",
  }

  for _, path in ipairs(candidates) do
    if fn.executable(path) == 1 then
      return { path, "--languageserver", "--hostPID", pid }
    end
  end

  notify(
    "OmniSharp executable not found. Install via: dotnet tool install -g omnisharp",
    log.levels.ERROR
  )
  return nil
end

function M.setup(capabilities)
  local extended = require("omnisharp_extended")
  local cmd = get_omnisharp_cmd()
  if not cmd then
    return { success = false, error = "OmniSharp not found" }
  end

  vim.lsp.config["omnisharp"] = {
    cmd = cmd,
    capabilities = tbl_deep_extend("force", capabilities or {}, extended.capabilities or {}),

    root_markers = { "*.sln", "*.csproj", "*.fsproj", "*.vbproj", "project.json", "omnisharp.json" },
    root_dir = function(fname)
      return find_project_root(fname)
    end,

    filetypes = { "cs", "vb", "razor", "cshtml" },

    flags = { debounce_text_changes = 150 },

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
        SpacingAroundBinaryOperator = "single",
        WrappingPreserveSingleLine = true,
        WrappingKeepStatementsOnSingleLine = true,
      },
      MsBuild = { LoadProjectsOnDemand = false },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
        EnableDecompilationSupport = true,
        DocumentAnalysisTimeoutMs = 30000,
        LocationTimeout = 10000,
      },
      Sdk = { IncludePrereleases = true },
      enableRoslynAnalyzers = true,
      enableEditorConfigSupport = true,
      enableMsBuildLoadProjectsOnDemand = false,
      waitForDebugger = false,
      loggingLevel = "information",
    },

    on_init = function(client)
      defer_fn(function()
        client.initialized = true
      end, 1000)
    end,

    on_attach = function(client, bufnr)
      if client.server_capabilities.semanticTokensProvider then
        lsp.semantic_tokens.start(bufnr, client.id)
      end
      defer_fn(function()
        client.initialized = true
        print("OmniSharp ready for buffer " .. bufnr)
      end, 2000)
    end,

    handlers = extended.handlers,
  }

  return { success = true, message = "OmniSharp LSP configured successfully" }
end

return M
