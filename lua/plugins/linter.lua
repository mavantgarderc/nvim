return {
    "nvimtools/none-ls.nvim", -- former "jose-elias-alvarez/null-ls.nvim"
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
  
      null_ls.setup({
        sources = {
          -- Formatting
          null_ls.builtins.formatting.black.with({
            extra_args = { "--fast" },
          }),
          null_ls.builtins.formatting.isort,
  
          -- Linting
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.diagnostics.pylint.with({
            extra_args = { "--disable=C0114,C0115,C0116" }, -- ignore docstring warnings
          }),
        },
      })
    end,
  }
  