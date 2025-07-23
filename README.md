Samurai-Odin at Tehran holding a Katana...

# Neovim Configuration
Converting my Vim setup on Nvim from scratch; nothing more...
& ofcourse a lil' bit of modernization... or perhaps a lot :)

### Iaijutsu
Keymaps are modularized to help the user engage; Au-DHD friendly.

You'll see three types at `lua/core/keymaps/`:
    - Customs
    - Native Re-implementations
    - Plugin Keymaps
This structures allow the user to read the config modules, as a reference study.

I'll appreciate any recommendations if you do by [gmail](manihabibinava@gmail.com) or submit issues.

> F-Keys are availablr for OGs, but not a good idea to take the habit (for sake of zen).

### Kendos
Among La Italia's best painters, Raphael was the best at harmonious painting & colorings...
`Raphael/`: Theme management with auto & user commands
    - FileType theme appliance; toggle to turn off.
    - Live theme-selector.
    - TODO: Integrations with Ghostty & Starship.
    - TODO: TOML & Hex Code support, powered by [Base16](https://github.com/RRethy/base16-nvim); TOML parser, etc. needed.


`lsp/`: Modular Per-language LSP Configuration; extensible & usage specific


`.editorconfig`: Cross-IDE style constraints to avoid conflicts with other devs & IDEs like Visual Studio, Visual Studio Code, etc.


Used out-of-the-box nvim distros & their lua-scripted features:
  - ~~NvChad~~
  - ~~Kickstart~~
  - ~~LunarVim~~
