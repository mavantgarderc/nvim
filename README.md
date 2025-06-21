And for them whom following Grimnir's path, The Allfather
obliged be armored by 100% layout seiðr...

# Neovim Configuration
Rebuild of my Vim setup on Nvim from scratch; nothing more...
& ofcourse a lil' bit of modernization... or more :)

## Notes
### Keymaps
Keymaps are modularized to help the user engage; good for memorization.

You'll see three types:
1. Plugin related keymaps, located in `lua/plugins/{plugin_config_file}`
2. Nvim keymaps located in `lua/core/keymaps/`, categorized:
  - Customs
  - Native Re-implementations
This structures allow the user to read the config modules, as a reference study.

I'll appreciate any recommendations if you do by [gmail](manihabibinava@gmail.com).

> [!NOTE] F-Keys
> They are available for OGs, but not a good idea to take the habbit (for sake of zen).

## To Do
- [x] `themepicker.lua` & `colors.lua`: Selecting & changing theme & filetype logic + related keymaps

- [x] `lsp/`: Per-language LSP Configuration

- [x] `.editorconfig`: Cross-IDE style constraints

- [x] Explore Out-Of-The-Box Configs' Ideas:
  - ~~NvChad~~
  - ~~Kickstart~~
  - ~~LunarVim~~

- [ ] `depgraph.lua`: Visualize project dependency graphs

- [ ] `vault.lua`: API key & credential loader (via `env`/`gpg`/file)

- [ ] `macros.lua`: Named, parameterized macros definition

- [ ] `sessionizer.lua`: Session save/resurrect logic
