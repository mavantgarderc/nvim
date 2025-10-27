return {
  setup = function(capabilities)
    require("lspconfig").rust_analyzer.setup({
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
          inlayHints = {
            chainingHints = true,
            parameterHints = true,
          },
        },
      },
    })
  end,
}
