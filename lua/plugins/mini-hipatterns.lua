return {
  "echasnovski/mini.hipatterns",
  version = "*",
  lazy = true,
  event = "BufReadPost",
  config = function()
    local hipatterns = require("mini.hipatterns")

    local color_vars = {}

    local palette_identifier = "󱗾 █ "

    local function scan_for_colors(bufnr)
      color_vars = {}
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        local name, hex = line:match("([%w_]+)%s*=%s*['\"]?(#%x%x%x%x%x%x)['\"]?")
        if name and hex then
          color_vars[name] = hex
        end
      end
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      callback = function(args)
        scan_for_colors(args.buf)
      end,
    })

    hipatterns.setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        xxx = { pattern = "%f[%w]()XXX()%f[%W]", group = "MiniHipatternsFixme" },
        warning = { pattern = "%f[%w]()WARNING()%f[%W]", group = "MiniHipatternsHack" },
        bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "MiniHipatternsFixme" },

        hex_color = hipatterns.gen_highlighter.hex_color({ style = "bg" }),

        palette_var = {
          pattern = "palette%.[%w_]+",
          group = function(_, match)
            local name = match:match("palette%.([%w_]+)")
            local hex = color_vars[name]
            if hex then
              return hipatterns.compute_hex_color_group(hex, "fg")
            end
            return nil
          end,
          extmark_opts = function(_, match)
            local name = match:match("palette%.([%w_]+)")
            local hex = color_vars[name]
            if not hex then
              return nil
            end
            local group = hipatterns.compute_hex_color_group(hex, "fg")
            return {
              virt_text = { { palette_identifier, group } },
              virt_text_pos = "inline",
              priority = 2000,
            }
          end,
        },

        pal_var = {
          pattern = "pal%.[%w_]+",
          group = function(_, match)
            local name = match:match("pal%.([%w_]+)")
            local hex = color_vars[name]
            if hex then
              return hipatterns.compute_hex_color_group(hex, "fg")
            end
            return nil
          end,
          extmark_opts = function(_, match)
            local name = match:match("pal%.([%w_]+)")
            local hex = color_vars[name]
            if not hex then
              return nil
            end
            local group = hipatterns.compute_hex_color_group(hex, "fg")
            return {
              virt_text = { { palette_identifier, group } },
              virt_text_pos = "inline",
              priority = 2000,
            }
          end,
        },

        rgb_color = {
          pattern = "rgb%(%d+,? %d+,? %d+%)",
          group = function(_, match)
            local r_str, g_str, b_str = match:match("rgb%((%d+),? (%d+),? (%d+)%)")
            local r, g, b = tonumber(r_str), tonumber(g_str), tonumber(b_str)
            return hipatterns.compute_hex_color_group("#" .. string.format("%02x%02x%02x", r, g, b), "bg")
          end,
        },

        rgba_color = {
          pattern = "rgba%(%d+,? %d+,? %d+,? [%d%.]+%)",
          group = function(_, match)
            local r_str, g_str, b_str = match:match("rgba%((%d+),? (%d+),? (%d+)")
            local r, g, b = tonumber(r_str), tonumber(g_str), tonumber(b_str)
            return hipatterns.compute_hex_color_group("#" .. string.format("%02x%02x%02x", r, g, b), "bg")
          end,
        },

        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            local h_str, s_str, l_str = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
            local h, s, l = tonumber(h_str), tonumber(s_str) / 100, tonumber(l_str) / 100

            local function hsl_to_rgb(hue, sat, light)
              if sat == 0 then
                local gray = math.floor(light * 255)
                return gray, gray, gray
              end

              local function hue_to_rgb(p, q, t)
                if t < 0 then
                  t = t + 1
                end
                if t > 1 then
                  t = t - 1
                end
                if t < 1 / 6 then
                  return p + (q - p) * 6 * t
                end
                if t < 1 / 2 then
                  return q
                end
                if t < 2 / 3 then
                  return p + (q - p) * (2 / 3 - t) * 6
                end
                return p
              end

              local q = light < 0.5 and light * (1 + sat) or light + sat - light * sat
              local p = 2 * light - q
              hue = hue / 360
              local r = hue_to_rgb(p, q, hue + 1 / 3)
              local g = hue_to_rgb(p, q, hue)
              local b = hue_to_rgb(p, q, hue - 1 / 3)
              return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
            end

            local r, g, b = hsl_to_rgb(h, s, l)
            return hipatterns.compute_hex_color_group("#" .. string.format("%02x%02x%02x", r, g, b), "bg")
          end,
        },

        ip_address = {
          pattern = "%d+%.%d+%.%d+%.%d+",
          group = "Number",
        },

        semver = {
          pattern = "v?%d+%.%d+%.%d+[%w%-]*",
          group = "Number",
        },
      },
    })
  end,
}
