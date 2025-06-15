local M = {}

M.theme_map = {
    tokyonight = {
        "tokyonight",
        "tokyonight-moon",    -- html, css
        "tokyonight-night",   -- json, jsonc
    },
    catppuccin = {
        "catppuccin-frappe",   -- md
        "catppuccin-macchiato",
        "catppuccin-mocha",    -- tex
    },
    rosepine = {
        "rose-pine",
        "rose-pine-moon",
        "rose-pine-main",
    },
    carbonfox = {
        "nightfox",           -- py
        "duskfox",            -- ts
        "nordfox",            -- js
        "terafox",
        "carbonfox",
    },
    kanagawa = {
        "kanagawa-wave",      -- sql
        "kanagawa-dragon",    -- nvim section
    },
    gruvbox = { "gruvbox"      },  -- cs
    oxocarbon = { "oxocarbon", },
    darkblue  = { "darkblue",  },
    desert    = { "desert",    },
    evening   = { "evening",   },
    habamax   = { "habamax",   },
    kohler    = { "kohler",    },
    slate     = { "slate",     },
    sorbet    = { "sorbet",    },
    torte     = { "torte",     },
    unokai    = { "unokai",    },
    vim       = { "vim",       },
    wildcharm = { "wildcharm", },
    zaibatsu  = { "zaibatsu",  },
}

M.filetype_themes = {
    -- nvim, project files & rc files
    alpha    = "kanagawa-dragon",
    netrw    = "kanagawa-dragon",
    lazy     = "kanagawa-dragon",
    help     = "kanagawa-dragon",
    lua      = "kanagawa-dragon",
    fugitive = "kanagawa-dragon",
    mason    = "kanagawa-dragon",
    tmux     = "kanagawa-dragon",
    toml     = "kanagawa-dragon",
    solution = "kanagawa-dragon",
    csproj   = "kanagawa-dragon",
    hyprlang = "kanagawa-dragon",
    zsh      = "kanagawa-dragon",
    sh       = "kanagawa-dragon",
    csv      = "kanagawa-dragon",
    conf     = "kanagawa-dragon",
    kdl      = "kanagawa-dragon",

    md    = "catppuccin-frappe",
    tex   = "catppuccin-mocha",
    xml   = "rose-pine",
    json  = "rose-pine-moon",
    jsonc = "rose-pine-moon",
    html  = "tokyonight",
    css   = "tokyonight",

    python      = "kanagawa-wave",
    sql         = "kanagawa-wave",
    cs          = "gruvbox",
    javascript  = "nordfox",
    typescript  = "duskfox",
}

return M
