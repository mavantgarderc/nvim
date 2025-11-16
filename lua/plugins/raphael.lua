local raphael = require("raphael")

return {
  dir = "~/projects/0-shelfs/CodeStorage/nvim-plugins/raphael.nvim",
  name = "raphael.nvim",
  -- "mavantgarderc/raphael.nvim",
  lazy = true,
  priority = 1000,

  keys = {
    { "<leader>tp", raphael.open_picker, desc = "Raphael: Configured themes" },
    { "<leader>t/", raphael.open_picker, desc = "Raphael: All other themes" },
    { "<leader>ta", raphael.toggle_auto, desc = "Raphael: Toggle auto-apply" },
    { "<leader>tR", raphael.refresh_and_reload, desc = "Raphael: Refresh themes" },
    { "<leader>ts", raphael.show_status, desc = "Raphael: Show status" },
  },

  opts = {
    default_theme = "kanagawa-paper-sunset",

    leader = "<leader>t",
    mappings = {
      next = ">",
      previous = "<",
      random = "t",
      auto = "a",
    },

    bookmark_group = false,
    recent_group = false,

    save_on_exit = false,

    sample_preview = {
      enabled = true,
      languages = { "lua", "python", "javascript" },
      relative_size = 0.5,
    },

    theme_aliases = {
      -- ["kanagawa-paper-ink"] = "Kanagawa-Ink",
    },

    theme_map = {

      prismpunk_kanagawa = {
        "kanagawa-paper-nightfall",
        "kanagawa-paper-sunset",
        -- "kanagawa-paper-dawn",
        "kanagawa-paper-edo",
        "kanagawa-paper-eclipse",
        "kanagawa-paper-storm",
        "kanagawa-paper-obsidian",
        "kanagawa-paper-crimsonnight",
        "kanagawa-paper-inko",
      },

      -- kanagawa = {
      --   "kanagawa-paper-ink",
      --   "base16-kanagawa",
      --   "base16-kanagawa-dragon",
      --   "kanagawa-wave",
      --   "kanagawa-dragon",
      -- },

      prismpunk_lantern_corps = {
        -- "lantern-corps-black",
        -- "lantern-corps-blue",
        -- "lantern-corps-gold",
        -- "lantern-corps-green",
        -- "lantern-corps-indigo",
        -- "lantern-corps-orange",
        "lantern-corps-phantom-balanced",
        "lantern-corps-phantom-choas",
        "lantern-corps-phantom-corrupted",
        -- "lantern-corps-red",
        "lantern-corps-ultraviolet-spectral",
        "lantern-corps-ultraviolet-veiled",
        -- "lantern-corps-violet",
        -- "lantern-corps-white",
        -- "lantern-corps-yellow",
      },

      -- prismpunk_bat_family = {
      --   "bat-family-alfred-penyworth",
      --   "bat-family-batgirl",
      --   "bat-family-batman-beyond",
      --   "bat-family-batman-classic",
      --   "bat-family-batman-dark-knight",
      --   "bat-family-batwing",
      --   "bat-family-bruce-wayne",
      --   "bat-family-cat-woman",
      --   "bat-family-huntress",
      --   "bat-family-lucious-fox",
      --   "bat-family-nightwing",
      --   "bat-family-red-hood",
      --   "bat-family-red-robin",
      --   "bat-family-robin",
      --   "bat-family-selina-kyle",
      -- },

      -- prismpunk_justice_league = {
      --   "justice-league-aquaman",
      --   "justice-league-batman",
      --   "justice-league-blue-beetle",
      --   "justice-league-booster-gold",
      --   "justice-league-captain-atom",
      --   "justice-league-cyborg",
      --   "justice-league-dr-fate",
      --   "justice-league-flash",
      --   "justice-league-green-arrow",
      --   "justice-league-green-lantern-john-stewart",
      --   "justice-league-hawkgirl",
      --   "justice-league-hawkman",
      --   "justice-league-martian-manhunter",
      --   "justice-league-superman",
      --   "justice-league-wonder-woman",
      -- },

      -- prismpunk_societyofshadows = {
      --   "society-of-shadows-athanasia-al-ghul",
      --   "society-of-shadows-bane",
      --   "society-of-shadows-ras-al-ghul",
      --   "society-of-shadows-talia-al-ghul",
      -- },

      -- everviolet = {
      --   "evergarden-fall",
      -- },

      -- black_metal = {
      --   "base16-black-metal-bathory",
      --   "base16-black-metal-dark-funeral",
      --   "base16-black-metal-gorgoroth",
      --   "base16-black-metal-khold",
      -- },

      -- zen = {
      --   "base16-grayscale-dark",
      --   "base16-icy",
      --   "base16-mountain",
      --   "base16-vesper",
      --   "base16-vulcan",
      -- },

      -- jukebox = {
      --   "base16-atelier-dune",
      --   "base16-atelier-forest",
      --   "base16-atelier-heath",
      --   "base16-atelier-plateau",
      --   "base16-shadesmear-dark",
      --   "base16-equilibrium-gray-dark",
      --   "base16-atelier-cave",
      --   "base16-penumbra-dark-contrast-plus",
      --   "base16-precious-dark-eleven",
      --   "base16-darkmoss", -- solidity
      --   "base16-tomorrow-night",
      --   "base16-darktooth",
      --   "base16-sandcastle",
      --   "base16-everforest-dark-hard",
      --   "base16-espresso",
      --   "base16-railscasts",
      --   "base16-darcula",
      --   "base16-ia-dark",
      -- },

      -- softs = {
      --   "base16-nord",
      --   "base16-eighties",
      --   "base16-everforest",
      --   "base16-ocean",
      --   "base16-oceanicnext",
      --   "base16-onedark",
      -- },

      -- tokyonight = {
      --   "tokyonight-moon", -- html, css
      --   "tokyonight-night", -- json, jsonc
      -- },
      --
      -- catppuccin = {
      --   "base16-catppuccin",
      --   "base16-catppuccin-mocha", -- tex
      --   "base16-catppuccin-macchiato", -- md
      --   "base16-da-one-ocean",
      -- },
      --
      -- carbonfox = {
      --   "nightfox", -- py
      --   "duskfox", -- ts
      --   "nordfox", -- js
      --   "terafox",
      --   "carbonfox",
      -- },
      --
      -- gruvbox = { -- dotnet
      --   "gruvbox",
      --   "base16-gruvbox-dark-hard",
      --   "base16-gruvbox-dark-pale",
      --   "base16-gruvbox-material-dark-hard",
      -- },
    },

    filetype_themes = {
      alpha = "kanagawa-paper-ink",
      netrw = "kanagawa-paper-ink",
      oil = "kanagawa-paper-ink",
      lazy = "kanagawa-paper-ink",
      help = "kanagawa-paper-ink",
      lua = "kanagawa-paper-ink",
      mason = "kanagawa-paper-ink",
      tmux = "kanagawa-paper-ink",
      kdl = "kanagawa-paper-ink",
      toml = "kanagawa-paper-ink",
      conf = "kanagawa-paper-ink",

      sh = "kanagawa-paper-ink",
      zsh = "kanagawa-paper-ink",
      hyprlang = "kanagawa-paper-ink",
      csv = "kanagawa-paper-ink",

      md = "base16-catppuccin-frappe",
      tex = "base16-catppuccin-mocha",

      cs = "gruvbox",
      csx = "base16-gruvbox-dark-hard",
      csproj = "base16-gruvbox-dark-pale",
      xml = "base16-gruvbox-dark-pale",
      solution = "base16-gruvbox-material-dark-hard",

      python = "kanagawa-wave",

      solidity = "base16-darkmoss",

      sql = "kanagawa-dragon",
      sqls = "kanagawa-dragon",

      html = "tokyonight",
      css = "tokyonight",
      javascript = "nordfox",
      typescript = "duskfox",
      json = "base16-rose-pine",
      jsonc = "base16-rose-pine",
    },
  },
}
