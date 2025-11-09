return {
  dir = "~/projects/0-shelfs/CodeStorage/nvim-plugins/prismpunk.nvim",
  name = "prismpunk.nvim",
  -- "mavantgarderc/prismpunk.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    require("prismpunk").setup({
      theme = "kanagawa/paper-edo",

      styles = {
        comments = { italic = true },
        keywords = { bold = false },
        functions = { bold = false },
        variables = {},
      },

      overrides = {
        colors = {},
        highlights = {},
      },

      integrations = {
        cmp = true,
        telescope = true,
        gitsigns = true,
        lualine = true,
      },

      terminal = {
        enabled = true,
        emulator = { "ghostty" },

        ghostty = {
          enabled = true,
          auto_reload = true,
          config_path = vim.fn.expand("~/.config/ghostty/themes/prismpunk.toml"),
        },

        alacritty = {
          enabled = true,
          auto_reload = true,
          config_path = vim.fn.expand("~/.config/alacritty/prismpunk.toml"),
        },
      },
    })
  end,
}
