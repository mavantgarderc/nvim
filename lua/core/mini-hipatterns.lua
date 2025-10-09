-- mini.hipatterns configuration
-- Place this in: ~/.config/nvim/lua/config/mini-hipatterns.lua

local hipatterns = require("mini.hipatterns")

hipatterns.setup({
  highlighters = {
    -- Highlight standalone "FIXME", "HACK", "TODO", "NOTE", "XXX", "WARNING", "BUG"
    fixme   = { pattern = "%f[%w]()FIXME()%f[%W]",   group = "MiniHipatternsFixme"   },
    hack    = { pattern = "%f[%w]()HACK()%f[%W]",    group = "MiniHipatternsHack"    },
    todo    = { pattern = "%f[%w]()TODO()%f[%W]",    group = "MiniHipatternsTodo"    },
    note    = { pattern = "%f[%w]()NOTE()%f[%W]",    group = "MiniHipatternsNote"    },
    xxx     = { pattern = "%f[%w]()XXX()%f[%W]",     group = "MiniHipatternsFixme"   },
    warning = { pattern = "%f[%w]()WARNING()%f[%W]", group = "MiniHipatternsHack"    },
    bug     = { pattern = "%f[%w]()BUG()%f[%W]",     group = "MiniHipatternsFixme"   },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),

    -- Highlight RGB colors like rgb(255, 128, 0)
    rgb_color = {
      pattern = "rgb%(%d+,? %d+,? %d+%)",
      group = function(_, match)
        local r, g, b = match:match("rgb%((%d+),? (%d+),? (%d+)%)")
        return MiniHipatterns.compute_hex_color_group("#" .. string.format("%02x%02x%02x", r, g, b), "bg")
      end,
    },

    -- Highlight RGBA colors like rgba(255, 128, 0, 0.5)
    rgba_color = {
      pattern = "rgba%(%d+,? %d+,? %d+,? [%d%.]+%)",
      group = function(_, match)
        local r, g, b = match:match("rgba%((%d+),? (%d+),? (%d+)")
        return MiniHipatterns.compute_hex_color_group("#" .. string.format("%02x%02x%02x", r, g, b), "bg")
      end,
    },

    -- Highlight HSL colors like hsl(120, 100%, 50%)
    hsl_color = {
      pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
      group = function(_, match)
        local h, s, l = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
        h, s, l = tonumber(h), tonumber(s) / 100, tonumber(l) / 100

        -- HSL to RGB conversion
        local function hsl_to_rgb(h, s, l)
          if s == 0 then
            local gray = math.floor(l * 255)
            return gray, gray, gray
          end

          local function hue_to_rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
          end

          local q = l < 0.5 and l * (1 + s) or l + s - l * s
          local p = 2 * l - q
          h = h / 360

          local r = hue_to_rgb(p, q, h + 1/3)
          local g = hue_to_rgb(p, q, h)
          local b = hue_to_rgb(p, q, h - 1/3)

          return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
        end

        local r, g, b = hsl_to_rgb(h, s, l)
        return MiniHipatterns.compute_hex_color_group("#" .. string.format("%02x%02x%02x", r, g, b), "bg")
      end,
    },

    -- Highlight shorthand hex colors like #RGB
    hex_short = {
      pattern = "#%x%x%x%f[%X]",
      group = function(_, match)
        local r, g, b = match:match("#(%x)(%x)(%x)")
        r, g, b = r..r, g..g, b..b
        return MiniHipatterns.compute_hex_color_group("#" .. r .. g .. b, "bg")
      end,
    },

    -- Highlight trailing whitespace
    trailing_space = { pattern = "%s+$", group = "Error" },

    -- Highlight URLs
    url = {
      pattern = "https?://[%w-._~:/?#%[%]@!$&\"()*+,;=]+",
      group = "MiniHipatternsNote",
    },

    -- Highlight email addresses
    email = {
      pattern = "[%w%._%+-]+@[%w%._%+-]+%.%a%a+",
      group = "MiniHipatternsNote",
    },

    -- Highlight issue/PR references like #123, GH-456
    issue_ref = {
      pattern = "[#@]%d+",
      group = "MiniHipatternsTodo",
    },

    gh_ref = {
      pattern = "GH%-(%d+)",
      group = "MiniHipatternsTodo",
    },

    -- Highlight dates in YYYY-MM-DD format
    date = {
      pattern = "%d%d%d%d%-%d%d%-%d%d",
      group = "MiniHipatternsNote",
    },

    -- Highlight ANSI color codes like \033[31m or \e[0m
    ansi_code = {
      pattern = "\\0?33%[[%d;]+m",
      group = "MiniHipatternsHack",
    },

    ansi_code_e = {
      pattern = "\\e%[[%d;]+m",
      group = "MiniHipatternsHack",
    },

    -- Highlight file paths (Unix-style and relative)
    unix_path = {
      pattern = "/[%w%./_%-]+",
      group = "Directory",
    },

    relative_path = {
      pattern = "%./[%w%./_%-]+",
      group = "Directory",
    },

    -- Highlight IP addresses
    ip_address = {
      pattern = "%d+%.%d+%.%d+%.%d+",
      group = "Number",
    },

    -- Highlight semantic versioning like v1.2.3 or 1.2.3
    semver = {
      pattern = "v?%d+%.%d+%.%d+[%w%-]*",
      group = "Number",
    },
  },
})
