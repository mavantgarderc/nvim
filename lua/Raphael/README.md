# Raphael Theme System - Setup Guide

## Overview

Raphael is a comprehensive Neovim theme system that supports both built-in colorschemes and custom TOML-based colorschemes. It provides an interactive picker, cycling capabilities, preview functionality, and extensive customization options.

## Directory Structure

```
lua/Raphael/
├── colors.lua              # Color definitions and configuration
├── init.lua                # Main module and setup
├── keymaps.lua             # Key mapping definitions
├── toml_parser.lua         # Custom TOML parser
├── colorschemes/           # TOML colorscheme files
│   └── midnight_ocean.toml # Sample TOML colorscheme
└── scripts/
    ├── autocmds.lua        # Auto commands and event handling
    ├── cmds.lua            # User commands
    ├── cycler.lua          # Colorscheme cycling functionality
    ├── loader.lua          # TOML colorscheme loader
    ├── picker.lua          # Interactive theme picker
    └── preview.lua         # Preview and comparison features
```

## Installation

1. **Copy the files** to your Neovim configuration directory in the structure shown above.

2. **Add to your `init.lua`**:
   ```lua
   -- Basic setup
   require("Raphael").setup()

   -- Or with custom configuration
   require("Raphael").setup({
     default_colorscheme = {
       name = "midnight_ocean",
       type = "toml"
     },
     keymaps = {
       leader = "<leader>t",
       global_keys = true
     },
     preview = {
       enabled = true,
       restore_on_exit = true
     }
   })
   ```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:RaphaelPicker [type]` | Open interactive theme picker |
| `:Rp [type]` | Alias for RaphaelPicker |
| `:RaphaelApply <name> [type]` | Apply specific colorscheme |
| `:RaphaelNext [type]` | Cycle to next colorscheme |
| `:RaphaelPrev [type]` | Cycle to previous colorscheme |
| `:RaphaelRandom [type]` | Apply random colorscheme |
| `:RaphaelAutoCycle [type] [seconds]` | Start auto-cycling |
| `:RaphaelStopCycle` | Stop auto-cycling |
| `:RaphaelPreview <name> [type] [duration]` | Preview colorscheme in window |
| `:RaphaelQuickPreview <name> [type] [ms]` | Quick preview with timeout |
| `:RaphaelCompare <name1> <name2> [...] [layout]` | Compare colorschemes |
| `:RaphaelSlideshow [type] [seconds] [loop]` | Start slideshow |
| `:RaphaelReload [name]` | Reload TOML colorschemes |
| `:RaphaelValidate` | Validate TOML colorschemes |
| `:RaphaelList [type]` | List available colorschemes |
| `:RaphaelInfo [name]` | Show colorscheme information |
| `:RaphaelStatus` | Show system status |
| `:RaphaelHelp` | Show command help |

**Types**: `all`, `toml`, `builtin`, `dark`, `light`

### Default Key Mappings

#### Theme Picker (prefix: `<leader>t`)
- `<leader>tp` - Open theme picker
- `<leader>tP` - Open TOML-only picker  
- `<leader>tb` - Open built-in only picker
- `<leader>td` - Open dark themes picker
- `<leader>tl` - Open light themes picker

#### Cycling
- `<leader>tn` - Next colorscheme
- `<leader>tN` - Previous colorscheme
- `<leader>tr` - Random colorscheme
- `<leader>t<C-n>` - Next TOML colorscheme
- `<leader>t<C-p>` - Previous TOML colorscheme

#### Auto-cycling
- `<leader>ta` - Toggle auto-cycle
- `<leader>ts` - Stop auto-cycle
- `<leader>ti` - Show cycle info

#### Preview
- `<leader>tv` - Preview current theme
- `<leader>tq` - Quick preview (with prompt)
- `<leader>tc` - Compare themes (with prompt)
- `<leader>tS` - Start slideshow

#### Management
- `<leader>tI` - Show theme info
- `<leader>t?` - Show system status
- `<leader>tR` - Reload TOML themes
- `<leader>tV` - Validate TOML themes

#### Global Keys
- `<F8>` - Previous colorscheme
- `<F9>` - Next colorscheme
- `<F10>` - Quick picker
- `<F7>` - Emergency reset to default

## Creating TOML Colorschemes

### TOML Structure

A TOML colorscheme file should have three main sections:

```toml
[metadata]
name = "your_theme_name"
display_name = "Your Theme Name"
author = "Your Name"
version = "1.0.0"
description = "Theme description"
background = "dark"  # or "light"

[colors]
# Define your color palette
bg = "#1a1a1a"
fg = "#ffffff"
red = "#ff6b6b"
green = "#51cf66"
blue = "#339af0"
# ... more colors

[highlights]
# Map Neovim highlight groups to your colors
Normal = { fg = "fg", bg = "bg" }
Comment = { fg = "comment", italic = true }
String = { fg = "green" }
Function = { fg = "blue" }
# ... more highlights
```

### Color References

In the `[highlights]` section, you can reference colors from the `[colors]` section by name, or use direct hex colors:

```toml
[highlights]
Normal = { fg = "fg", bg = "bg" }           # References colors.fg and colors.bg
Error = { fg = "#ff0000", bold = true }     # Direct hex color
```

### Highlight Attributes

Supported attributes in highlight definitions:
- `fg` - Foreground color
- `bg` - Background color  
- `sp` - Special color (for undercurl, etc.)
- `bold` - Bold text (true/false)
- `italic` - Italic text (true/false)
- `underline` - Underlined text (true/false)
- `undercurl` - Undercurl (true/false)
- `strikethrough` - Strikethrough (true/false)
- `reverse` - Reverse colors (true/false)

## Interactive Picker Usage

When you open the picker with `:RaphaelPicker` or `<leader>tp`:

### Navigation
- `j` / `↓` - Move down
- `k` / `↑` - Move up

### Actions
- `<Enter>` - Apply selected theme
- `p` - Toggle preview
- `/` - Filter themes
- `c` - Clear filter
- `q` / `<Esc>` - Close picker
- `?` - Show help

## Advanced Features

### Auto-cycling
```vim
:RaphaelAutoCycle dark 3    " Auto-cycle dark themes every 3 seconds
:RaphaelStopCycle           " Stop auto-cycling
```

### Comparison
```vim
:RaphaelCompare midnight_ocean gruvbox dracula horizontal
```

### Slideshow
```vim
:RaphaelSlideshow toml 2 false   " TOML themes, 2 seconds each, no loop
```

### Preview
```vim
:RaphaelPreview midnight_ocean toml 5000   " Preview for 5 seconds
:RaphaelQuickPreview gruvbox builtin       " Quick preview with auto-restore
```

## Configuration Options

```lua
require("Raphael").setup({
  -- directory for TOML colorschemes
  toml_dir = vim.fn.stdpath("config") .. "/lua/Raphael/colorschemes/",
  
  -- default colorscheme
  default_colorscheme = {
    name = "midnight_ocean",
    type = "toml"
  },
  
  -- auto-save current colorscheme across sessions
  auto_save = true,
  
  -- auto-switch based on background setting
  auto_switch_background = false,
  
  -- time-based switching (day/night themes)
  time_based_switching = false,
  
  -- preview settings
  preview = {
    enabled = true,
    timeout = 100,
    restore_on_exit = true
  },
  
  -- picker UI settings
  picker = {
    show_type = true,
    show_preview = true,
    max_height = 15,
    max_width = 50,
    border = "rounded"
  },
  
  -- key mappings
  keymaps = {
    enabled = true,
    leader = "<leader>t",
    global_keys = true,
    which_key = true,
    context_aware = true
  },
  
  -- plugin integrations
  integrations = {
    telescope = true,
    lualine = true,
    nvim_tree = true,
    which_key = true
  }
})
```

## Plugin Integrations

### Telescope
If Telescope is installed, you can use:
```vim
:Telescope raphael
```

### Lualine
Add the Raphael component to your lualine config:
```lua
require('lualine').setup({
  sections = {
    lualine_c = { vim.g.raphael_lualine_component }
  }
})
```

### Which-Key
Automatic integration provides organized key mapping descriptions.

## TOML Colorscheme Development

### Quick Start
1. Create a new TOML file in `lua/Raphael/colorschemes/`
2. Use the template structure shown above
3. Add the colorscheme name to `colors.lua` in the `toml_colorschemes` list
4. Test with `:RaphaelValidate`
5. Apply with `:RaphaelApply your_theme_name toml`

### Best Practices
- Use descriptive color names in the `[colors]` section
- Reference colors by name in `[highlights]` for maintainability
- Include comprehensive metadata
- Test with `:RaphaelValidate` before use
- Use semantic color names (e.g., `error`, `warning`, `info`)

### Validation
The system automatically validates TOML colorschemes for:
- Required sections (`metadata`, `colors`, `highlights`)
- Valid color references
- Proper TOML syntax
- Required metadata fields

## Troubleshooting

### Common Issues
1. **"Invalid TOML colorscheme"** - Run `:RaphaelValidate` to see specific errors
2. **"Colorscheme not found"** - Check the name in `colors.lua` and file exists
3. **"Failed to load TOML colorscheme"** - Check file permissions and syntax

### Debug Mode
Enable debug mode for detailed logging:
```lua
require("Raphael").setup({
  debug = true
})
```

### Health Check
Run the health check to diagnose issues:
```lua
require("Raphael").show_health()
```

## API Reference

### Main Functions
```lua
local raphael = require("Raphael")

-- basic operations
raphael.open_picker()           -- open theme picker
raphael.apply_colorscheme(name, type)  -- apply colorscheme
raphael.cycle_next()            -- next colorscheme
raphael.preview_colorscheme(name, type, duration)  -- preview

-- get information
raphael.get_current_colorscheme()  -- current theme info
raphael.get_all_colorschemes()     -- all available themes
```

### Advanced Usage
```lua
-- custom cycling through specific themes
local cycler = require("Raphael.scripts.cycler")
cycler.cycle_through_list({"gruvbox", "dracula", "midnight_ocean"}, true)

-- custom preview comparison
local preview = require("Raphael.scripts.preview")
preview.compare_colorschemes(colorscheme_list, "vertical")

-- load and modify TOML colorscheme
local loader = require("Raphael.scripts.loader")
local colorscheme = loader.load_toml_colorscheme("midnight_ocean")
-- modify colorscheme.colors or colorscheme.highlights
-- then apply manually
```
