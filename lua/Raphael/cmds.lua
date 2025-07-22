local M = {}

local theme_loader = require("Raphael.loader")
local theme_preview = require("Raphael.preview")
local theme_picker = require("Raphael.picker")
local theme_cycler = require("Raphael.cycler")
local api = vim.api
local notify = vim.notify
local log = vim.log

-- === Setup User Commands ===
function M.setup()
    -- Theme Preview Command
    api.nvim_create_user_command("PT", function(opts)
        local delay = tonumber(opts.args) or 700
        theme_preview.preview_all_themes(delay)
    end, {
        nargs = "?",
        desc = "Preview all themes (optional delay in ms)",
    })

    -- Theme Selector Command
    api.nvim_create_user_command("TT", function(opts)
        local theme = opts.args
        if theme and theme ~= "" then
            if theme_loader.is_theme_available(theme) then
                theme_loader.load_theme(theme)
                notify("Theme set to: " .. theme, log.levels.INFO)
            else
                notify("Theme '" .. theme .. "' not available", log.levels.ERROR)
            end
        else
            theme_picker.select_theme()
        end
    end, {
        nargs = "?",
        complete = function() return theme_loader.get_theme_list() end,
        desc = "Set theme by name or open picker if no argument",
    })

    -- Theme Cycler Commands
    api.nvim_create_user_command("TN", function() theme_cycler.cycle_next_theme() end, {
        desc = "Cycle to next theme",
    })

    api.nvim_create_user_command("TP", function() theme_cycler.cycle_prev_theme() end, {
        desc = "Cycle to previous theme",
    })

    api.nvim_create_user_command("TR", function() theme_cycler.random_theme() end, {
        desc = "Set random theme",
    })

    -- Create user command
    api.nvim_create_user_command('ToggleAutoTheme', function()
        M.toggle_auto_theme()
    end, { desc = "Toggle automatic theme switching based on filetype" })

    -- Theme Info Command
    api.nvim_create_user_command("TI", function()
        local current = theme_loader.get_current_theme()
        local themes = theme_loader.get_theme_list()
        local index = theme_cycler.get_current_index()

        local info =
            string.format("Current theme: %s\nAvailable themes: %d\nCycle index: %d", current or "none", #themes, index)

        notify(info, log.levels.INFO, { title = "Theme Info" })
    end, {
        desc = "Show theme information",
    })
end

return M
