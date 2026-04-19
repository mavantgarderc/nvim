local M = {}

local function find_root(bufname)
	local patterns = { "%.sln$", "%.csproj$", "%.fsproj$" }
	for _, pattern in ipairs(patterns) do
		local match = vim.fs.find(function(name)
			return name:match(pattern) ~= nil
		end, {
			path = vim.fs.dirname(bufname),
			upward = true,
			limit = 1,
		})
		if match and match[1] then
			return vim.fs.dirname(match[1])
		end
	end
	return vim.fs.dirname(bufname)
end

function M.setup(capabilities)
	local cmd = vim.fn.expand("~/.dotnet/tools/csharp-ls")

	if vim.fn.executable(cmd) ~= 1 then
		vim.notify(
			"[lsp@csharp_ls] csharp-ls not found. Install: dotnet tool install --global csharp-ls",
			vim.log.levels.WARN
		)
		return
	end

	vim.lsp.config("csharp_ls", {
		cmd = { cmd },
		filetypes = { "cs" },
		root_dir = function(bufnr, on_dir)
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			on_dir(find_root(bufname))
		end,
		capabilities = capabilities,

		settings = {
			csharp = {
				solution = nil,
				inlayHints = {
					enableInlayHintsForParameters = true,
					enableInlayHintsForLiteralParameters = true,
					enableInlayHintsForIndexerParameters = true,
					enableInlayHintsForObjectCreationParameters = true,
					enableInlayHintsForOtherParameters = true,
					suppressInlayHintsForParametersThatDifferOnlyBySuffix = false,
					suppressInlayHintsForParametersThatMatchMethodIntent = false,
					suppressInlayHintsForParametersThatMatchArgumentName = true,
					enableInlayHintsForTypes = true,
					enableInlayHintsForImplicitVariableTypes = true,
					enableInlayHintsForLambdaParameterTypes = true,
					enableInlayHintsForImplicitObjectCreation = true,
				},
				completion = {
					dotnetProvideRegexCompletions = true,
					dotnetShowCompletionItemsFromUnimportedNamespaces = true,
					dotnetShowNameCompletionSuggestions = true,
				},
				diagnostics = {
					analyzerDiagnosticsScope = "fullSolution", -- or "openFiles"
				},
			},
		},

		on_attach = function(client, bufnr)
			-- format on save if server supports it
			if client:supports_method("textDocument/formatting") then
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
					end,
				})
			end
		end,
	})

	vim.lsp.enable("csharp_ls")
end

function M.extend()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client or client.name ~= "csharp_ls" then
				return
			end
		end,
	})
end

return M
