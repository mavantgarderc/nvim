local M = {}

M.theme_map = {
    tokyonight = {
        "tokyonight",
        "tokyonight-moon",   -- html, css
        "tokyonight-night",  -- json, jsonc
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
    gruvbox = {
        "gruvbox",            -- cs
    },
    carbonfox = {
        "nightfox",           -- py
        "duskfox",            -- ts
        "nordfox",            -- js
        "terafox",
        "carbonfox",
    },
    oxocarbon = {
        "oxocarbon",
    },
    kanagawa = {
        "kanagawa-wave",      -- sql
        "kanagawa-dragon",    -- nvim section
    },
    darkblue = {
        "darkblue",
    },
    desert = {
        "desert",
    },
    evening = {
        "evening",
    },
    habamax = {
        "habamax",
    },
    kohler = {
        "kohler",
    },
    slate = {
        "slate",
    },
    sorbet = {
        "sorbet",
    },
    torte = {
        "torte",
    },
    unokai = {
        "unokai",
    },
    vim = {
        "vim",
    },
    wildcharm = {
        "wildcharm",
    },
    zaibatsu = {
        "zaibatsu",
    },
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
    kdl      = "kanagawa-dragon",
    -- markup files, containers, etc.
    md    = "catppuccin-frappe",
    tex   = "catppuccin-mocha",
    xml   = "rose-pine",
    json  = "rose-pine-moon",
    jsonc = "rose-pine-moon",
    html  = "tokyonight",
    css   = "tokyonight",
    -- source files
    python      = "kanagawa-wave",
    sql         = "kanagawa-wave",
    cs          = "gruvbox",
    javascript  = "nordfox",
    typescript  = "duskfox",
}

return M
