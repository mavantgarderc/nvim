local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	vim.lsp.config("pyright", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.completionProvider = nil
		end,

		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
					inlayHints = {
						chainingHints = true,
						parameterHints = true,
					},
				},
			},
		},
	})

	vim.lsp.config("jedi_language_server", {
		capabilities = capabilities,

		on_attach = function(client)
			client.server_capabilities.diagnosticProvider = nil
			client.server_capabilities.documentFormattingProvider = false
		end,

		init_options = {
			completion = {
				disableSnippets = false,
				resolveEagerly = true,
			},
			diagnostics = {
				enable = false,
			},
			hover = {
				enable = true,
			},
		},
	})

	vim.lsp.config("ruff", {
		capabilities = capabilities,

		on_attach = function(client, bufnr)
			client.server_capabilities.hoverProvider = false
			client.server_capabilities.completionProvider = nil

			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
					params.context = { only = { "source.organizeImports.ruff" }, diagnostics = {} }
					local result = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
					for _, action in pairs(result and result.result or {}) do
						if action.edit then
							vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
						end
					end
					vim.lsp.buf.format({ bufnr = bufnr, name = "ruff" })
				end,
				desc = "ruff: organize imports + format on save",
			})
		end,

		init_options = {
			settings = {
				lineLength = 120,
			},
		},
	})

	vim.api.nvim_create_user_command("MyPy", function()
		local root = vim.fs.root(0, { "pyproject.toml", "setup.cfg", "mypy.ini", ".mypy.ini", ".git" })
			or vim.fn.getcwd()

		vim.notify("mypy: running on " .. root .. " …", vim.log.levels.INFO)

		vim.fn.jobstart({ "mypy", "--show-error-codes", "--no-color-output", "." }, {
			cwd = root,
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function(_, data)
				if not data or (#data == 1 and data[1] == "") then
					return
				end
				local items = {}
				for _, line in ipairs(data) do
					local file, lnum, col, msg = line:match("^(.+):(%d+):(%d+): (.+)$")
					if not file then
						file, lnum, msg = line:match("^(.+):(%d+): (.+)$")
						col = "1"
					end
					if file then
						table.insert(items, {
							filename = vim.fs.joinpath(root, file),
							lnum = tonumber(lnum),
							col = tonumber(col) or 1,
							text = msg,
							type = msg:match("^error") and "E" or "W",
						})
					end
				end
				if #items > 0 then
					vim.schedule(function()
						vim.fn.setqflist(items, "r")
						vim.cmd("copen")
						vim.notify("mypy: " .. #items .. " finding(s)", vim.log.levels.WARN)
					end)
				else
					vim.schedule(function()
						vim.notify("mypy: clean ✓", vim.log.levels.INFO)
					end)
				end
			end,
			on_stderr = function(_, data)
				if data and #data > 1 then
					vim.schedule(function()
						vim.notify("mypy stderr: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
					end)
				end
			end,
		})
	end, { desc = "Run MyPy on project root → quickfix" })

	vim.lsp.enable("pyright")
	vim.lsp.enable("jedi_language_server")
	vim.lsp.enable("ruff")
end

function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "<leader>pv", function()
		local root = client.config.root_dir or vim.fn.getcwd()
		local venv = vim.env.VIRTUAL_ENV or vim.fn.finddir(".venv", root .. ";")
		vim.notify("pyright venv: " .. (venv ~= "" and venv or "none"), vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Show virtualenv info" }))

	vim.keymap.set("n", "<leader>pi", function()
		vim.lsp.buf.code_action({
			apply = true,
			context = { only = { "source.organizeImports" }, diagnostics = {} },
		})
	end, vim.tbl_extend("force", opts, { desc = "Organize imports (Python)" }))

	vim.keymap.set("n", "<leader>pm", "<cmd>MyPy<CR>", vim.tbl_extend("force", opts, { desc = "Run MyPy (project)" }))
end

return M
