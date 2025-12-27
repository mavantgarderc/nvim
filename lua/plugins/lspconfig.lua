return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"j-hui/fidget.nvim",
			"stevearc/conform.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"nvimtools/none-ls.nvim",
			"aznhe21/actions-preview.nvim",
			"andythigpen/nvim-coverage",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local conform = require("conform")

			-- Setup fidget for LSP status notifications
			require("fidget").setup({})

			-- Mason setup
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Mason LSP config setup
			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"pyright",
					"omnisharp",
					"html",
					"cssls",
					"texlab",
					"sqls",
					"solidity_ls",
					"dockerls",
					"jsonls",
					"gopls",
					"rust_analyzer",
					"zls",
					"graphql",
					"yamlls",
					"marksman",
					"bashls",
					"vimls",
				},
				handlers = {
					function(server_name)
						local server_config = require("lsp.servers." .. server_name)
						if server_config and server_config.setup then
							server_config.setup()
						else
							local capabilities = cmp_nvim_lsp.default_capabilities()
							capabilities.textDocument.completion.completionItem.snippetSupport = true
							capabilities.textDocument.foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							}

							lspconfig[server_name].setup({
								capabilities = capabilities,
								on_attach = function(client, bufnr)
									-- Setup keymaps when LSP attaches
									require("lsp.shared").setup_keymaps()
								end,
							})
						end
					end,
				},
			})

			-- Setup diagnostics
			require("lsp.shared").setup_diagnostics()

			-- Setup conform (formatter)
			require("lsp.shared").setup_conform()
			require("lsp.shared").setup_format_keymap()

			-- Setup LSP UI enhancements
			local border = "rounded"
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
			vim.diagnostic.config({
				float = { border = border },
			})

			-- Setup LSP autoformat
			require("lsp.shared").setup_autoformat()

			-- Setup LSP UI
			require("lsp.shared").setup_lsp_ui()

			-- Setup workspace caching
			require("lsp.shared").setup_workspace_caching()

			-- Setup monorepo support
			require("lsp.monorepo").setup_lsp_with_monorepo()

			-- Setup auto-install
			local auto_install = require("lsp.auto-install")
			auto_install.check_and_prompt()
		end,
	},
}