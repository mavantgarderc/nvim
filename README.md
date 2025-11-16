Odin, The Ronin in Athens holding a Katana...

> Built not for everyone — but for those who want to master their own tools.

# Neovim Configuration

> Hagakure

A wandering soul with a Vim config, now rebuilding it from scratch in Neovim.

The goal is to keep the spirit, upgrade the sword — sharpened with Lua and modern tooling.

### Iaijutsu Sword Attacks - Dance of the Sword
Keymaps are modularized for clarity and ease of discovery — AuDHD-friendly by design.

Designed to be both informative and self-guiding.

You'll see three types at `lua/core/keymaps/`:
- Customs
- Native Re-implementations
- Plugin Keymaps

This structure allows the user to explore mappings as standalone modules and reference points.

> F-Keys are available for OGs, but not a habit worth building (for the sake of zen).

### Kendos Sword Schools - Techniques & Forms
*Kendo* means *The Way of The Sword*.

#### `lsp/`
Modular Per-language LSP Configuration; extensible & usage specific
  - Add your language server's config to `lua/lsp/servers/`, then inject to `lua/lsp/shared.lua`.

Inspired by out-of-the-box Lua-based distros:
  - ~~NvChad~~
  - ~~Kickstart~~
  - ~~LunarVim~~

###  Yoroi of the Sword Master - Tools of Warlike
*Yoroi* means *Samurai Equipments*.

> Full plugin config lives in `lua/plugins/`, modularized by purpose & intent.

> This config uses [`lazy.nvim`](https://github.com/folke/lazy.nvim) for plugin loading and startup optimization.
Plugins are lazy-loaded, organized under `lua/plugins/`, and grouped by function.

`plugins/`: configured like a blade — swift, silent, and aligned in purpose
  - [`raphael.nvim`](https://github.com/mavantgarderc/raphael.nvim): Theme management plugin with file-type specific theme appliance
  - [`pantheon.nvim`](https://github.com/mavantgarderc/pantheon.nvim): Theme plugin based on fictional characters
  - [`dadbod.nvim`](https://github.com/tpope/vim-dadbod): UI + cmp: SQL interaction with RDBMS systems (Postgres, Oracle, SSMS, etc.)
  - [`flash.nvim`](https://github.com/folke/flash.nvim): Navigate precisely - no more `H/J/K/L` spam
  - [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim): Stage hunks, view diffs, navigate history — buffer-local
  - [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim): Custom tabline/statusline with style
  - [`undotree.nvim`](https://github.com/mbbill/undotree): Visual undo/redo timeline

And of course: Telescope, cmp, luasnip, DAP — the usual suspects.

---

Open an issue or [email](mailto:manihabibinava@gmail.com) me - suggestions are welcome.

---

## Getting Started

```sh
# Clone the config
git clone https://github.com/mavantgarderc/nvim ~/.config/nvim

# Launch Neovim
nvim
```

Requires Neovim 0.9+.

Linux/macOS. Windows WSL2 supported.

First launch will trigger plugin sync via `lazy.nvim`. Use `:checkhealth` to verify setup.

## License
This project is licensed under the [MIT License](./LICENSE).
