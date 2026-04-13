local M = {}

local function find_project_root(arg)
	local fname = type(arg) == "number" and vim.api.nvim_buf_get_name(arg) or arg
	if not fname or fname == "" then
		return nil
	end

	local patterns = {
		"*.sln",
		"*.csproj",
		"*.fsproj",
		"*.vbproj",
		"project.json",
		"omnisharp.json",
	}

	local match = vim.fs.find(patterns, { upward = true, path = fname })
	return match[1] and vim.fs.dirname(match[1]) or nil
end

local function get_omnisharp_cmd()
	local pid = tostring(vim.fn.getpid())
	local home = os.getenv("HOME")

	local candidates = {
		"omnisharp",
		"OmniSharp",
		vim.fn.stdpath("data") .. "/mason/bin/omnisharp",
		vim.fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp",
		"/usr/local/bin/omnisharp",
		"/usr/bin/omnisharp",
		home .. "/.local/bin/omnisharp",
		home .. "/.dotnet/tools/omnisharp",
	}

	for _, path in ipairs(candidates) do
		if vim.fn.executable(path) == 1 then
			return { path, "--languageserver", "--hostPID", pid }
		end
	end

	vim.notify("[omnisharp] executable not found", vim.log.levels.ERROR)
	return nil
end

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	local ok_ext, extended = pcall(require, "omnisharp_extended")
	if not ok_ext then
		extended = {}
	end

	local cmd = get_omnisharp_cmd()
	if not cmd then
		return
	end

	vim.lsp.config("omnisharp", {
		cmd = cmd,

		filetypes = { "cs", "vb", "razor", "cshtml" },
		root_dir = find_project_root,

		capabilities = vim.tbl_deep_extend("force", capabilities or {}, extended.capabilities or {}),

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

			inlayHints = {
				chainingHints = true,
				parameterHints = true,
			},

			Sdk = { IncludePrereleases = true },

			enableRoslynAnalyzers = true,
			enableEditorConfigSupport = true,
			enableMsBuildLoadProjectsOnDemand = false,

			waitForDebugger = false,
			loggingLevel = "information",
		},

		on_init = function(client)
			client.initialized = true
		end,

		on_attach = function(client, bufnr)
			if client.server_capabilities.semanticTokensProvider then
				vim.lsp.semantic_tokens.start(bufnr, client.id)
			end
		end,

		handlers = extended.handlers or {},
	})

	vim.lsp.enable("omnisharp")
end

return M
