local M = {}

M.theme_map = {
    base16 = {



        -- "base16-kanagawa",

        -- "base16-oxocarbon-dark",


        -- "base16-rose-pine",
        -- "base16-horizon-dark",
        -- "base16-ashes",
        -- "base16-ayu-mirage",
        -- "base16-black-metal-bathory",
        -- "base16-black-metal-dark-funeral",
        -- "base16-black-metal-gorgoroth",
        -- "base16-black-metal-khold",
        -- "base16-darkmoss",
        -- "base16-eighties",
        -- "base16-equilibrium-gray-dark",
        -- "base16-everforest-dark-hard",
        -- "base16-framer",
        -- "base16-penumbra-dark-contrast-plus",
        -- "base16-precious-dark-eleven",
        -- "base16-sandcastle",
        -- "base16-schemer-medium",
        -- "base16-selenized-black",
        -- "base16-tomorrow-night",

    },
    --
    -- tokyonight = {
    --     "tokyonight",
    --     "tokyonight-moon",    -- html, css
    --     "tokyonight-night",   -- json, jsonc
    -- },
    -- catppuccin = {
        -- "catppuccin-macchiato", -- md (replace the base16...)
        -- "catppuccin-mocha",    -- tex (replace the base16...)
        -- "base16-catppuccin",
        -- "base16-catppuccin-macchiato",
        -- "base16-catppuccin-mocha",
    -- },
    -- carbonfox = {
    --     "nightfox",           -- py
    --     "duskfox",            -- ts
    --     "nordfox",            -- js
    --     "terafox",
    --     "carbonfox",
    -- },
    kanagawa = {
        -- "base16-kanagawa",
        -- "kanagawa-wave",      -- sql (replace the base16...)
        -- "kanagawa-dragon",    -- nvim section
        -- "kanagawa-paper-ink",
    },
    -- gruvbox = {
    --     "gruvbox",  -- cs
    --     "base16-gruvbox-dark-hard",
    --     "base16-gruvbox-dark-pale",
    --     "base16-gruvbox-material-dark-hard",
    -- },
    -- oxocarbon = { "oxocarbon", },
    -- gotham    = { "gotham"     },

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

    md    = "catppuccin-frappe",
    tex   = "catppuccin-mocha",
    xml   = "rose-pine",
    json  = "rose-pine-moon",
    jsonc = "rose-pine-moon",
    html  = "tokyonight",
    css   = "tokyonight",

    python      = "kanagawa-wave",
    sql         = "kanagawa-wave",
    -- cs          = "gruvbox",
    javascript  = "nordfox",
    typescript  = "duskfox",
}

return M
