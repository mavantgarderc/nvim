return {
	setup = function(capabilities)
		require("lspconfig").graphql.setup({
			capabilities = capabilities,
			filetypes = { "graphql", "typescriptreact", "javascriptreact" },
			inlayHints = {
				chainingHints = true,
				parameterHints = true,
			},
		})
	end,
}
