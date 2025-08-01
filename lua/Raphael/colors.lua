local M = {}

M.theme_map = {
  everviolet = {
    "evergarden-fall",
  },

  black_metal = {
    "base16-black-metal-bathory",
    "base16-black-metal-dark-funeral",
    "base16-black-metal-gorgoroth",
    "base16-black-metal-khold",
  },

  gotham = {
    "gotham",
    "base16-gotham",
  },

  zen = {
    "base16-grayscale-dark",
    "base16-icy",
    "base16-mountain",
    "base16-vesper",
    "base16-vulcan",
  },

  jukebox = {
    "base16-atelier-dune",
    "base16-atelier-forest",
    "base16-atelier-heath",
    "base16-atelier-plateau",
    "base16-shadesmear-dark",
    "base16-equilibrium-gray-dark",
    "base16-atelier-cave",
    "base16-penumbra-dark-contrast-plus",
    "base16-precious-dark-eleven",
    "base16-darkmoss",
    "base16-tomorrow-night",
    "base16-darktooth",
    "base16-sandcastle",
    "base16-everforest-dark-hard",
    "base16-espresso",
    "base16-railscasts",
    "base16-darcula",
    "base16-ia-dark",
  },

  softs = {
    "base16-nord",
    "base16-eighties",
    "base16-everforest",
    "base16-ocean",
    "base16-oceanicnext",
    "base16-onedark",
  },

  tokyonight  = {
    "tokyonight-moon",      -- html, css
    "tokyonight-night",     -- json, jsonc
  },

  catppuccin  = {
    "base16-catppuccin",
    "base16-catppuccin-mocha",         -- tex
    "base16-catppuccin-macchiato",     -- md
    "base16-da-one-ocean",
  },

  carbonfox   = {
    "nightfox",     -- py
    "duskfox",      -- ts
    "nordfox",      -- js
    "terafox",
    "carbonfox",
  },

  kanagawa    = {
    "base16-kanagawa",
    "base16-kanagawa-wave",     -- sql
    "kanagawa-dragon",          -- nvim section
    "kanagawa-paper-ink",
  },

  gruvbox     = {
    "gruvbox",     -- cs
    "base16-gruvbox-dark-hard",
    "base16-gruvbox-dark-pale",
    "base16-gruvbox-material-dark-hard",
  },



}


M.filetype_themes = {
  alpha      = "kanagawa-paper-ink",
  netrw      = "kanagawa-paper-ink",
  oil        = "kanagawa-paper-ink",
  lazy       = "kanagawa-paper-ink",
  help       = "kanagawa-paper-ink",
  lua        = "kanagawa-paper-ink",
  mason      = "kanagawa-paper-ink",
  tmux       = "kanagawa-paper-ink",
  kdl        = "kanagawa-paper-ink",
  toml       = "kanagawa-paper-ink",
  conf       = "kanagawa-paper-ink",

  sh         = "kanagawa-paper-ink",
  zsh        = "kanagawa-paper-ink",
  hyprlang   = "kanagawa-paper-ink",
  csv        = "kanagawa-paper-ink",

  md         = "base16-catppuccin-frappe",
  tex        = "base16-catppuccin-mocha",

  cs         = "gruvbox",
  csx        = "base16-gruvbox-dark-hard",
  csproj     = "base16-gruvbox-dark-pale",
  xml        = "base16-gruvbox-dark-pale",
  solution   = "base16-gruvbox-material-dark-hard",

  python     = "kanagawa-wave",

  sql        = "kanagawa-wave",
  sqls       = "kanagawa-wave",

  html       = "tokyonight",
  css        = "tokyonight",
  javascript = "nordfox",
  typescript = "duskfox",
  json       = "base16-rose-pine",
  jsonc      = "base16-rose-pine",
}

return M
