local M = {}

local fs = vim.fs
local fn = vim.fn
local lsp = vim.lsp
local defer_fn = vim.defer_fn
local notify, log = vim.notify, vim.log

-- Find project root safely
local function find_project_root(arg)
  local fname = arg
  if type(fname) == "number" then
    fname = vim.api.nvim_buf_get_name(fname)
  end
  if not fname or fname == "" then
    return nil
  end

  local patterns = {
    "*.sln", "*.csproj", "*.fsproj", "*.vbproj",
    "project.json", "omnisharp.json",
  }
  local match = fs.find(patterns, { upward = true, path = fname })
  if match and match[1] then
    return fs.dirname(match[1])
  end
  return nil
end

-- Resolve OmniSharp executable
local function get_omnisharp_cmd()
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

  require("lspconfig").omnisharp.setup({
    cmd = cmd,
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities or {},
      extended.capabilities or {}
    ),

    root_dir = find_project_root,
    filetypes = { "cs", "vb", "razor", "cshtml" },

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
  })

  return { success = true, message = "OmniSharp LSP configured successfully" }
end

return M
