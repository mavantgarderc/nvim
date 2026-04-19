local shared = require("lsp.shared")
local M = {}

function M.setup()
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	local capabilities = shared.get_capabilities()

	vim.lsp.config("solidity", {
		capabilities = capabilities,

		filetypes = { "solidity" },
		single_file_support = true,

		root_dir = vim.fs.root(0, {
			"hardhat.config.js",
			"hardhat.config.ts",
			"foundry.toml",
			"truffle-config.js",
			"truffle.js",
			"remappings.txt",
			".git",
		}),

		init_options = {
			enableTelemetry = false,
		},

		settings = {
			solidity = {
				compileUsingRemoteVersion = "latest",
				formatter = "forge",
				enabledAsYouTypeCompilationErrorCheck = true,
				validationDelay = 1500,
				packageDefaultDependenciesContractsDirectory = "contracts",
				packageDefaultDependenciesDirectory = "lib",
				defaultCompiler = "remote",
				analysisLevel = "full",
				enableIncrementalCompilation = true,
				inlayHints = {
					chainingHints = true,
					parameterHints = true,
				},
			},
		},

		on_attach = function(client, bufnr)
			if shared.setup_keymaps then
				pcall(shared.setup_keymaps, bufnr)
			end

			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						local ok, val = pcall(vim.api.nvim_buf_get_var, bufnr, "lsp_format_on_save")
						if ok and val == false then
							return
						end

						vim.lsp.buf.format({
							bufnr = bufnr,
							filter = function(c)
								return c.name == "solidity"
							end,
						})
					end,
				})
			end
		end,
	})

	vim.lsp.enable("solidity")
	M.setup_solidity_autocmds()
end

function M.setup_solidity_autocmds()
	local aug = vim.api.nvim_create_augroup("SolidityLSP", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = aug,
		pattern = "solidity",
		callback = function()
			vim.opt_local.tabstop = 4
			vim.opt_local.shiftwidth = 4
			vim.opt_local.expandtab = true
			vim.opt_local.commentstring = "// %s"
			vim.opt_local.spell = false
			vim.opt_local.foldmethod = "syntax"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = aug,
		pattern = "*.sol",
		callback = function(args)
			vim.bo[args.buf].filetype = "solidity"
		end,
	})
end

return M
