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
      return { path, "--languageserver", "--hostPID", pid }
    end
  end

  notify("OmniSharp executable not found. Install via: dotnet tool install -g omnisharp", log.levels.ERROR)
  return nil
end

function M.setup(capabilities)
  local extended = require("omnisharp_extended")
  local cmd = get_omnisharp_cmd()

  if not cmd then
    return {
      success = false,
      error = "OmniSharp executable not found. Install via: dotnet tool install -g omnisharp"
    }
  end

  local ok, err = pcall(function()
    vim.lsp.config("omnisharp", {
      cmd = cmd,
      capabilities = tbl_deep_extend("force", capabilities or {}, extended.capabilities or {}),

      root_dir = function(fname)
        local primary_root = find_project_root(fname)
        if primary_root then
          return primary_root
        end
        local util = require("lspconfig.util") -- only for root_pattern
        return util.root_pattern(
          "*.sln",
          "*.csproj",
          "*.fsproj",
          "*.vbproj",
          "project.json",
          "omnisharp.json"
        )(fname)
      end,

      filetypes = { "cs", "vb", "razor", "cshtml" },

      flags = {
        debounce_text_changes = 150,
      },

      on_init = function(client, initialize_result)
        defer_fn(function()
          client.initialized = true
        end, 1000)
      end,

      on_exit = function(code, signal, client_id)
        if code ~= 0 then
          -- handle exit logging if you want
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
          -- [snipped: same as your original FormattingOptions ...]
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
  end)

  if not ok then
    return {
      success = false,
      error = "Failed to configure OmniSharp LSP: " .. tostring(err)
    }
  end

  return {
    success = true,
    message = "OmniSharp LSP configured successfully"
  }
end

return M
