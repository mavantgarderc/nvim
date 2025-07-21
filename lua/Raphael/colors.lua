local M = {}

M.theme_map = {

    black_metal = {
        "base16-black-metal-bathory",
        "base16-black-metal-dark-funeral",
        "base16-black-metal-gorgoroth",
        "base16-black-metal-khold",
    },

    base16 = {
        "base16-horizon-dark",
        "base16-ashes",
        "base16-ayu-mirage",
        "base16-darkmoss",
        "base16-eighties",
        "base16-equilibrium-gray-dark",
        "base16-everforest-dark-hard",
        "base16-framer",
        "base16-penumbra-dark-contrast-plus",
        "base16-precious-dark-eleven",
        "base16-sandcastle",
        "base16-schemer-medium",
        "base16-selenized-black",
        "base16-tomorrow-night",
    },

    tokyonight = {
        "tokyonight",
        "tokyonight-moon",    -- html, css
        "tokyonight-night",   -- json, jsonc
    },

    catppuccin = {
        "base16-catppuccin",
        "base16-catppuccin-mocha",     -- tex
        "base16-catppuccin-macchiato", -- md
    },

    carbonfox = {
        "nightfox",           -- py
        "duskfox",            -- ts
        "nordfox",            -- js
        "terafox",
        "carbonfox",
    },

    kanagawa = {
        "base16-kanagawa",
        "base16-kanagawa-wave",   -- sql
        "kanagawa-dragon",        -- nvim section
        "kanagawa-paper-ink",
    },

    gruvbox = {
        "gruvbox",  -- cs
        "base16-gruvbox-dark-hard",
        "base16-gruvbox-dark-pale",
        "base16-gruvbox-material-dark-hard",
    },

    rose_pine = { "base16-rose-pine", },
    oxocarbon = { "base16-oxocarbon-dark", },
    gotham    = { "gotham", },

}


M.filetype_themes = {
    alpha    = "kanagawa-paper-ink",
    netrw    = "kanagawa-paper-ink",
    oil      = "kanagawa-paper-ink",
    lazy     = "kanagawa-paper-ink",
    help     = "kanagawa-paper-ink",
    lua      = "kanagawa-paper-ink",
    mason    = "kanagawa-paper-ink",
    tmux     = "kanagawa-paper-ink",
    toml     = "kanagawa-paper-ink",
    solution = "kanagawa-paper-ink",
    csproj   = "kanagawa-paper-ink",
    hyprlang = "kanagawa-paper-ink",
    zsh      = "kanagawa-paper-ink",
    sh       = "kanagawa-paper-ink",
    csv      = "kanagawa-paper-ink",
    conf     = "kanagawa-paper-ink",
    kdl      = "kanagawa-paper-ink",

    md    = "base16-catppuccin-frappe",
    tex   = "base16-catppuccin-mocha",
    xml   = "base16-rose-pine",
    json  = "base16-rose-pine",
    jsonc = "base16-rose-pine",
    html  = "tokyonight",
    css   = "tokyonight",

    python      = "kanagawa-wave",
    sql         = "kanagawa-wave",
    cs          = "gruvbox",
    javascript  = "nordfox",
    typescript  = "duskfox",
}

return M
