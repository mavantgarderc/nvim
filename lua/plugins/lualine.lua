return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "lewis6991/gitsigns.nvim",
    },
    event = 'VeryLazy',
    config = function()
        local fn = vim.fn
        local bo = vim.bo
        local api = vim.api
        local map = vim.keymap.set

        local hide_in_width = function() return fn.winwidth(0) > 80 end

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = "󰯈 ", warn = " " },
            colored = false,
            update_in_insert = true,
            always_visible = true,
        }

        local diff = {
            "diff",
            colored = false,
            symbols = { added = " ", modified = " ", removed = " " },
            cond = hide_in_width,
        }

        local branch = {
            "branch",
            icons_enabled = true,
            --icon = "",
            icon = "󰝨",
            cond = function()
                return fn.executable('git') == 1 and
                       (fn.isdirectory('.git') == 1 or fn.system('git rev-parse --git-dir 2>/dev/null'):match('%.git'))
            end,
            fmt = function(str)
                if str == '' or str == nil then
                    return ''
                end
                return str
            end
        }

        local location = {
            "location",
            padding = 0,
        }

        local progress = function()
            -- local chars = {
            --     "⡀   ", "⡀⡀  ", "⡀⡀⡀ ", "⡀⡀⡀⡀",
            --     "⡄⡀⡀⡀", "⡄⡄⡀⡀", "⡄⡄⡄⡀", "⡄⡄⡄⡄",
            --     "⡆⡄⡄⡄", "⡆⡆⡄⡄", "⡆⡆⡆⡄", "⡆⡆⡆⡆",
            --     "⡇⡆⡆⡆", "⡇⡇⡆⡆", "⡇⡇⡇⡆", "⡇⡇⡇⡇",
            -- }
            local chars = {
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
            }
            local current_line = fn.line(".")
            local total_lines = fn.line("$")
            local index = math.ceil((current_line / total_lines) * #chars)
            return chars[index] or chars[#chars]
        end

        local show_filetype_text = true
        local filetype = function()
            local ft = bo.filetype
            if ft == "" then return "" end
            local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(ft, { default = true })
            return show_filetype_text and (icon .. " " .. ft) or icon
        end

        vim.defer_fn(function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = { "alpha", "dashboard", "NvimTree", "Outline" },
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 100,
                        tabline = 100,
                        winbar = 100,
                    },
                },
                sections = {
                    lualine_a = { branch, diagnostics },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = { diff, filetype },
                    lualine_y = { location },
                    lualine_z = { progress },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = { progress },
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
            })
        end, 50)

        map("n", "<leader>tf", function()
            show_filetype_text = not show_filetype_text
            require("lualine").refresh()
        end, { desc = "Toggle filetype text" })
    end,
}
