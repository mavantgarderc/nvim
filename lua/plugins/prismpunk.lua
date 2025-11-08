return {
  "mavantgarderc/prismpunk.nvim",
  priority = 1000,
  lazy = false,
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
      emulator = { "ghostty", "alacritty" },

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
  }),
}
