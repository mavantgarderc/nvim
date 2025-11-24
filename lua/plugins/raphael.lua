local raphael = require("raphael")

return {
  "mavantgarderc/raphael.nvim",
  lazy = false,
  priority = 1000,

  keys = {
    {
      "<leader>tp",
      function()
        raphael.open_picker({ only_configured = true })
      end,
      desc = "Raphael: Configured themes",
    },
    {
      "<leader>t/",
      function()
        raphael.open_picker({ exclude_configured = true })
      end,
      desc = "Raphael: All other themes",
    },
    {
      "<leader>ta",
      function()
        raphael.toggle_auto()
      end,
      desc = "Raphael: Toggle auto-apply",
    },
    {
      "<leader>tR",
      function()
        raphael.refresh_and_reload()
      end,
      desc = "Raphael: Refresh themes",
    },
    {
      "<leader>ts",
      function()
        raphael.show_status()
      end,
      desc = "Raphael: Show status",
    },
  },

  opts = {
    default_theme = "kanagawa-paper-sunset",

    enable_pickker = true,
    bookmark_group = false,
    recent_group = false,

    save_on_exit = false,

    sample_preview = {
      enabled = true,
      relative_size = 0.5,
      languages = {
        "lua",
        "python",
        "javascript",
        "rust",
        "go",
        "ruby",
        "sh",
        "sql",
      },
    },

    theme_aliases = {
      -- ["kanagawa-paper-ink"] = "Kanagawa-Ink",
    },

    theme_map = {
      prism_punk = {
        "aquapunk",
        "atompunk",
        "biopunk",
        "cyberpunk",
        "decopunk",
        "steampunk",
        "dieselpunk",
        "nanopunk",
        "solarpunk",
        "stonepunk",
        "splatterpunk",
        "techpunk",
        "clockpunk",
      },

      prism_watchmen = {
        "watchmen-dr-manhattan",
        "watchmen-nite-owl",
        "watchmen-ozymandias",
        "watchmen-rorschach",
        "watchmen-silk-spectre",
        "watchmen-the-comedian",
      },

      prism_nvim = {
        "prism-sorbet",
        "prism-habamax",
        "prism-slate",
        "prism-quiet",
        "prism-retrobox",
      },

      prism_tmnt = {
        "tmnt-donatello",
        "tmnt-leonardo",
        "tmnt-michelangelo",
        "tmnt-raphael",
        "tmnt-splinter",
        "tmnt-last-ronin",
        "tmnt-casey-jones",
        "tmnt-april-oneal",
        "tmnt-shredder",
      },

      prismpunk_kanagawa = {
        "kanagawa-paper-nightfall",
        "kanagawa-paper-sunset",
        "kanagawa-paper-dawn",
        "kanagawa-paper-edo",
        "kanagawa-paper-eclipse",
        "kanagawa-paper-storm",
        "kanagawa-paper-obsidian",
        "kanagawa-paper-crimsonnight",
        "kanagawa-paper-dragon",
      },

      prismpunk_lantern_corps = {
        "lantern-corps-black",
        "lantern-corps-blue",
        "lantern-corps-gold",
        "lantern-corps-green",
        "lantern-corps-indigo",
        "lantern-corps-orange",
        "lantern-corps-phantom-balanced",
        "lantern-corps-phantom-chaos",
        "lantern-corps-phantom-corrupted",
        "lantern-corps-red",
        "lantern-corps-ultraviolet-spectral",
        "lantern-corps-ultraviolet-veiled",
        "lantern-corps-violet",
        "lantern-corps-white",
        "lantern-corps-yellow",
      },

      prismpunk_bat_family = {
        "bat-family-alfred-penyworth",
        "bat-family-batgirl",
        "bat-family-batman-beyond",
        "bat-family-batman-classic",
        "bat-family-bruce-wayne",
        "bat-family-catwoman",
        "bat-family-huntress",
        "bat-family-lucius-fox",
        "bat-family-nightwing",
        "bat-family-red-hood",
        "bat-family-red-robin",
        "bat-family-robin",
        "bat-family-selina-kyle",
      },

      prismpunk_justice_league = {
        "justice-league-adam-strange",
        "justice-league-aquaman",
        "justice-league-batman",
        "justice-league-black-canary",
        "justice-league-blue-beetle",
        "justice-league-booster-gold",
        "justice-league-captain-atom",
        "justice-league-cyborg",
        "justice-league-dr-fate",
        "justice-league-firestorm",
        "justice-league-flash",
        "justice-league-green-arrow",
        "justice-league-green-lantern-kyle-rayner",
        "justice-league-green-lantern-guy-gardner",
        "justice-league-green-lantern-hal-jordan",
        "justice-league-green-lantern-jessica-cruz",
        "justice-league-green-lantern-john-stewart",
        "justice-league-hawkgirl",
        "justice-league-hawkman",
        "justice-league-martian-manhunter",
        "justice-league-mr-terrific",
        "justice-league-shazam",
        "justice-league-spectre",
        "justice-league-superman",
        "justice-league-wonder-woman",
      },

      prismpunk_crimesyndicate = {
        "crime-syndicate-ultraman",
        "crime-syndicate-owlman",
        "crime-syndicate-superwoman",
        "crime-syndicate-johnny-quick",
        "crime-syndicate-power-ring",
        "crime-syndicate-sea-king",
        "crime-syndicate-grid",
        "crime-syndicate-deadeye",
        "crime-syndicate-deathstorm",
        "crime-syndicate-martian",
        "crime-syndicate-dr-chaos",
        "crime-syndicate-black-siren",
      },

      prismpunk_leagueofassasins = {
        "league-of-assassins-bane",
        "league-of-assassins-ras-al-ghul",
        "league-of-assassins-talia",
      },
    },

    filetype_themes = {
      alpha = "kanagawa/paper-edo",
      netrw = "kanagawa/paper-edo",
      minifiles = "kanagawa/paper-edo",
      lazy = "kanagawa/paper-edo",
      help = "kanagawa/paper-edo",
      lua = "kanagawa/paper-edo",
      mason = "kanagawa/paper-edo",
      tmux = "kanagawa/paper-edo",
      kdl = "kanagawa/paper-edo",
      toml = "kanagawa/paper-edo",
      conf = "kanagawa/paper-edo",

      sh = "kanagawa/paper-edo",
      zsh = "kanagawa/paper-edo",
      hyprlang = "kanagawa/paper-edo",
      csv = "kanagawa/paper-edo",

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
