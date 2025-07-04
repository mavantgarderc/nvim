return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "lewis6991/gitsigns.nvim",
    },
    event = "VeryLazy",
    config = function()
        local fn = vim.fn
        local map = vim.keymap.set
        local loop = vim.loop
        local lsp = vim.lsp
        local v = vim.v
        local o = vim.o
        local g = vim.g
        local bo = vim.bo
        local treesitter = vim.treesitter
        local api = vim.api
        local defer_fn = vim.defer_fn
        local schedule_wrap = vim.schedule_wrap
        local notify = vim.notify
        local log = vim.log

        local hide_in_width = function() return fn.winwidth(0) > 80 end

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = "󰯈 ", warn = " " },
            colored = false,
            update_in_insert = false,
            always_visible = true,
        }

        local diff = {
            "diff",
            colored = false,
            symbols = { added = " ", modified = " ", removed = " " },
            cond = hide_in_width,
        }

        local branch = {
            "branch",
            icons_enabled = true,
            --icon = "",
            icon = "󰝨",
            cond = function()
                return fn.executable("git") == 1
                    and (fn.isdirectory(".git") == 1 or fn.system("git rev-parse --git-dir 2>/dev/null"):match("%.git"))
            end,
            fmt = function(str)
                if str == "" or str == nil then return "" end
                return str
            end,
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

        local show_filetype_text = false
        local filetype = function()
            local ft = bo.filetype
            if ft == "" then return "" end
            local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(ft, { default = true })
            return show_filetype_text and (icon .. " " .. ft) or icon
        end

        local cache = {
            lsp_clients =    { value = "", last_update = 0 },
            python_env =     { value = "", last_update = 0 },
            dotnet_project = { value = "", last_update = 0 },
            test_status =    { value = "", last_update = 0 },
            debug_status =   { value = "", last_update = 0 },
            current_symbol = { value = "", last_update = 0 },
        }

        local function get_cached_value(key, update_fn, ttl)
            ttl = ttl or 500
            local now = loop.hrtime() / 1000000
            local cached = cache[key]

            if not cached or (now - cached.last_update) > ttl then
                cached.value = update_fn()
                cached.last_update = now
                cache[key] = cached
            end

            return cached.value
        end

        local function get_lsp_clients()
            return get_cached_value("lsp_clients", function()
                local clients = lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end

                local names = {}
                for _, client in pairs(clients) do
                    table.insert(names, client.name)
                 end
                return " " .. table.concat(names, ",")
            end, 10000) -- cache: 10 sec
        end

        local function get_python_env()
            return get_cached_value("python_env", function()
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    return " " .. fn.fnamemodify(venv, ":t")
                end

                local conda_env = os.getenv("CONDA_DEFAULT_ENV")
                if conda_env and conda_env ~= "base" then
                    return " " .. conda_env
                end

                return ""
            end, 30000) -- cache: 30 sec
        end

        local function get_dotnet_project()
            return get_cached_value("dotnet_project", function()
                local cwd = fn.getcwd()
                local sln_files = fn.glob(cwd .. "/*.sln", false, true)
                local csproj_files = fn.glob(cwd .. "/**/*.csproj", false, true)

                if #sln_files > 0 then
                    return " " .. fn.fnamemodify(sln_files[1], ":t:r")
                elseif #csproj_files > 0 then
                    return " " .. fn.fnamemodify(csproj_files[1], ":t:r")
                end

                return ""
            end, 60000) -- cache: 60 sec
        end

        local function get_test_status()
            return get_cached_value("test_status", function()
                local pytest_job = fn.system("pgrep -f pytest 2>/dev/null")
                if pytest_job ~= "" and v.shell_error == 0 then
                    return "󰙨 pytest"
                end

                local dotnet_job = fn.system("pgrep -f \"dotnet test\" 2>/dev/null")
                if dotnet_job ~= "" and v.shell_error == 0 then
                    return "󰙨 dotnet"
                end

                return ""
            end, 15000) -- cache: 15 sec
        end

        local function get_debug_status()
            return get_cached_value("debug_status", function()
                local ok, dap = pcall(require, "dap")
                if ok then
                    local session = dap.session()
                    if session then
                        local breakpoints = require("dap.breakpoints").get()
                        local bp_count = 0
                        for _, _ in pairs(breakpoints) do
                            bp_count = bp_count + 1
                        end
                        return " " .. session.adapter.name .. " (" .. bp_count .. " bp)"
                    end
                end
                return ""
            end, 5000) -- cache: 5 sec
        end

        local function get_database_status()
            local ft = bo.filetype
            if ft == "sql" or ft == "mysql" or ft == "postgresql" then
                return " DB"
            end
            return ""
        end

        local function get_cwd()
            local cwd = fn.getcwd()
            local home = os.getenv("HOME")
            if home and cwd:sub(1, #home) == home then
                cwd = "~" .. cwd:sub(#home + 1)
            end
            return " " .. fn.pathshorten(cwd)
        end

        local function get_file_info()
            -- local encoding = bo.fileencoding ~= "" and bo.fileencoding or o.encoding
            -- local format = bo.fileformat
            -- local filetype = bo.filetype ~= "" and bo.filetype or "no ft"
            -- local format_icon = format == "unix" and "LF" or (format == "dos" and "CRLF" or format)
            -- return string.format("%s | %s | %s", filetype, encoding, format_icon)
            local encoding = bo.fileencoding ~= "" and bo.fileencoding or o.encoding
            local format = bo.fileformat
            local filetype = bo.filetype ~= "" and bo.filetype or "no ft"
            local format_icon = format == "unix" and "LF" or (format == "dos" and "CRLF" or format)
            return string.format("%s", filetype)
        end

        local function get_indent_info()
            local expandtab = bo.expandtab
            local tabstop = bo.tabstop
            local shiftwidth = bo.shiftwidth

            if expandtab then
                return "␣" .. shiftwidth
            else
                return "󰌒 " .. tabstop
            end
        end

        local function get_navic_breadcrumbs()
            local ok, navic = pcall(require, "nvim-navic")
            if ok and navic.is_available() then
                return navic.get_location()
            end
            return ""
        end

        local function get_current_symbol()
            return get_cached_value("current_symbol", function()
                local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
                if not ok then return "" end

                local current_node = ts_utils.get_node_at_cursor()
                if not current_node then return "" end

                local function_node = current_node
                while function_node do
                    local node_type = function_node:type()
                    if node_type == "function_definition" or
                       node_type == "method_definition" or
                       node_type == "function_declaration" or
                       node_type == "method_declaration" then
                        local name_node = function_node:field("name")[1]
                        if name_node then
                            local name = treesitter.get_node_text(name_node, 0)
                            return "⚡" .. name
                        end
                        break
                    end
                    function_node = function_node:parent()
                end

                return ""
            end, 200) -- cache: 0.2 sec
        end

        local function has_lsp()
            return #lsp.get_clients({ bufnr = 0 }) > 0
        end

        local function has_python_env()
            return get_python_env() ~= ""
        end

        local function has_dotnet_project()
            return get_dotnet_project() ~= ""
        end

        local function has_test_running()
            return get_test_status() ~= ""
        end

        local function has_debug_session()
            return get_debug_status() ~= ""
        end

        local function is_sql_file()
            local ft = bo.filetype
            return ft == "sql" or ft == "mysql" or ft == "postgresql"
        end

        local function has_navic()
            local ok, navic = pcall(require, "nvim-navic")
            return ok and navic.is_available()
        end

        local function has_symbol()
            return get_current_symbol() ~= ""
        end

        local function get_lualine_theme()
            local colorscheme = g.colors_name or "default"

            local theme_map = {
                require("colors")
            }

            local mapped_theme = theme_map[colorscheme:lower()]
            if mapped_theme then
                local success = pcall(function()
                    require("lualine.themes." .. mapped_theme)
                end)
                if success then
                    return mapped_theme
                end
            end

            local success = pcall(function()
                require("lualine.themes." .. colorscheme)
            end)
            if success then
                return colorscheme
            end

            return "auto"
        end

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = get_lualine_theme(),
                component_separators = { left = "", right = "" },
                section_separators   = { left = "", right = "" },
                disabled_filetypes   = {
                    statusline = { "alpha", "dashboard", "lazy", "TelescopePrompt" },
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline  = true,
                globalstatus         = false,
                refresh = {
                    statusline = 5000,
                    tabline    = 5000,
                    winbar     = 5000,
                },
            },
            sections = {
                lualine_a = { branch },
                lualine_b = { diagnostics },
                lualine_c = {
                    { get_navic_breadcrumbs, cond = has_navic,  },
                    { get_current_symbol,    cond = has_symbol, },
                },
                lualine_x = {
                    diff,
                    filetype,
                },
                lualine_y = { location, },
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
            tabline = {
                lualine_a = { "tabs" },
                lualine_b = { get_cwd },
                lualine_c = { "filename" },
                lualine_x = {},
                lualine_y = {
                    --[[get_indent_info]]
                    { get_lsp_clients,     cond = has_lsp,            },
                    { get_python_env,      cond = has_python_env,     },
                    { get_dotnet_project,  cond = has_dotnet_project, },
                    { get_test_status,     cond = has_test_running,   },
                    { get_debug_status,    cond = has_debug_session,  },
                    { get_database_status, cond = is_sql_file,        },
                    get_file_info,
                    },
                lualine_z = {}
            },
            winbar = {},
            inactive_winbar = {},
        })

        -- === === === === ===
        -- MAPPINGS & AUTO-CMDs
        local group = api.nvim_create_augroup("LualineRefresh", { clear = true })
        api.nvim_create_autocmd({
            "LspAttach", "LspDetach" }, {
            group = group,
            callback = function()
                cache.lsp_clients = { value = "", last_update = 0 }
                defer_fn(function()
                    require("lualine").refresh()
                end, 500)
            end,
        })

        api.nvim_create_autocmd("ColorScheme", {
            group = group,
            callback = function()
                defer_fn(function()
                    local new_theme = get_lualine_theme()
                    require("lualine").setup({
                        options = {
                            icons_enabled = true,
                            theme = get_lualine_theme(),
                            component_separators = { left = "", right = "" },
                            section_separators   = { left = "", right = "" },
                            disabled_filetypes   = {
                                statusline = { "alpha", "dashboard", "lazy", "TelescopePrompt" },
                                winbar = {},
                            },
                            ignore_focus = {},
                            always_divide_middle = true,
                            always_show_tabline  = true,
                            globalstatus         = false,
                            refresh = {
                                statusline = 5000,
                                tabline    = 5000,
                                winbar     = 5000,
                            },
                        },
                        sections = {
                            lualine_a = { branch },
                            lualine_b = { diagnostics },
                            lualine_c = {
                                { get_navic_breadcrumbs, cond = has_navic,  },
                                { get_current_symbol,    cond = has_symbol, },
                            },
                            lualine_x = {
                                diff,
                                filetype,
                            },
                            lualine_y = { location, },
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
                        tabline = {
                            lualine_a = { "tabs" },
                            lualine_b = { get_cwd },
                            lualine_c = { "filename" },
                            lualine_x = {},
                            lualine_y = {
                                --[[get_indent_info]]
                                { get_lsp_clients,     cond = has_lsp,            },
                                { get_python_env,      cond = has_python_env,     },
                                { get_dotnet_project,  cond = has_dotnet_project, },
                                { get_test_status,     cond = has_test_running,   },
                                { get_debug_status,    cond = has_debug_session,  },
                                { get_database_status, cond = is_sql_file,        },
                                get_file_info,
                            },
                            lualine_z = {}
                        },
                        winbar = {},
                        inactive_winbar = {},
                    })
                    require("lualine").refresh()
                end, 100)
            end,
        })

        local timer = loop.new_timer()
        if timer then
            timer:start(60000, 60000, schedule_wrap(function()
                cache.test_status  = { value = "", last_update = 0 }
                cache.debug_status = { value = "", last_update = 0 }

                if has_test_running() or has_debug_session() then
                    require("lualine").refresh()
                end
            end))
        end

        map("n", "<leader>tf", function()
            show_filetype_text = not show_filetype_text
            require("lualine").refresh()
        end, { silent = true })

        map("n", "<leader>tt", function()
            local new_theme = get_lualine_theme()
            local current_colorscheme = g.colors_name or "default"
            notify("Scheme: " .. current_colorscheme .. " → Lualine: " .. new_theme, log.levels.INFO)
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = get_lualine_theme(),
                    component_separators = { left = "", right = "" },
                    section_separators   = { left = "", right = "" },
                    disabled_filetypes   = {
                        statusline = { "alpha", "dashboard", "lazy", "TelescopePrompt" },
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline  = true,
                    globalstatus         = false,
                    refresh = {
                        statusline = 5000,
                        tabline    = 5000,
                        winbar     = 5000,
                    },
                },
                sections = {
                    lualine_a = { branch },
                    lualine_b = { diagnostics },
                    lualine_c = {
                        { get_navic_breadcrumbs, cond = has_navic,  },
                        { get_current_symbol,    cond = has_symbol, },
                    },
                    lualine_x = {
                        diff,
                        filetype,
                    },
                    lualine_y = { location, },
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
                tabline = {
                    lualine_a = { "tabs" },
                    lualine_b = { get_cwd },
                    lualine_c = { "filename" },
                    lualine_x = {},
                    lualine_y = {
                        --[[get_indent_info]]
                        { get_lsp_clients,     cond = has_lsp,            },
                        { get_python_env,      cond = has_python_env,     },
                        { get_dotnet_project,  cond = has_dotnet_project, },
                        { get_test_status,     cond = has_test_running,   },
                        { get_debug_status,    cond = has_debug_session,  },
                        { get_database_status, cond = is_sql_file,        },
                        get_file_info,
                    },
                    lualine_z = {}
                },
                winbar = {},
                inactive_winbar = {}
            })
            require("lualine").refresh()
        end, { silent = true })
    end,
}
