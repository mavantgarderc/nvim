local M = {}

local theme_loader = require("Raphael.loader")
local o = vim.o
local api = vim.api
local log = vim.log
local map = vim.keymap.set
local notify = vim.notify
local schedule = vim.schedule
local deepcopy = vim.deepcopy
local cmd = vim.cmd

-- === Enhanced Theme Picker ===
function M.create_theme_picker()
    local themes = theme_loader.get_theme_list()
    local original_theme = theme_loader.get_current_theme()
    local preview_theme = nil
    local filter_text = ""
    local filtered_themes = themes
    local search_mode = false

    if #themes == 0 then
        notify("No themes available", log.levels.WARN)
        return
    end

    -- Create picker window
    local buf = api.nvim_create_buf(false, true)
    local width = math.floor(o.columns * 0.2)
    local height = math.min(#themes + 4, math.floor(o.lines * 0.7))
    local row = math.floor((o.lines - height) / 2)
    local col = math.floor((o.columns - width) / 2)

    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " Theme Picker ",
        title_pos = "center"
    })

    -- Filter themes based on search text
    local function filter_themes()
        if filter_text == "" then
            filtered_themes = deepcopy(themes)
        else
            filtered_themes = {}
            local pattern = filter_text:lower()
            for _, theme in ipairs(themes) do
                if theme:lower():find(pattern, 1, true) then
                    table.insert(filtered_themes, theme)
                end
            end
        end
    end

    -- Get status line text based on current mode
    local function get_status_text()
        if search_mode then
            return "Search: " .. filter_text
        elseif filter_text ~= "" then
            return "Filter: " .. filter_text .. " (/ to search, c to clear)"
        else
            return "Enter: select | r: random | q/Esc: quit"
        end
    end

    -- Populate buffer with themes
    local function update_buffer()
        filter_themes()

        local lines = {
            get_status_text(),
            ""
        }

        local current_theme = theme_loader.get_current_theme()

        if #filtered_themes == 0 then
            table.insert(lines, "  No matching themes found")
        else
            for i, theme in ipairs(filtered_themes) do
                local prefix = (theme == current_theme) and "● " or "  "
                table.insert(lines, prefix .. theme)
            end
        end

        api.nvim_buf_set_option(buf, "modifiable", true)
        api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        api.nvim_buf_set_option(buf, "modifiable", false)

        return lines
    end

    local lines = update_buffer()

    -- Set cursor to current theme or first theme
    local function set_initial_cursor()
        local cursor_line = 3 -- Start after headers
        local current_theme = theme_loader.get_current_theme()

        for i, theme in ipairs(filtered_themes) do
            if theme == current_theme then
                cursor_line = i + 2
                break
            end
        end

        if #filtered_themes > 0 and cursor_line <= #lines then
            api.nvim_win_set_cursor(win, { cursor_line, 2 })
        end
    end

    set_initial_cursor()

    -- Highlight current line
    local ns_id = api.nvim_create_namespace("theme_picker")
    local function update_highlight()
        api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
        if not search_mode then
            local line = api.nvim_win_get_cursor(win)[1]
            if line > 2 and line <= #lines then
                api.nvim_buf_add_highlight(buf, ns_id, "Visual", line - 1, 0, -1)
            end
        end
    end

    -- Enhanced preview with error handling
    local function preview_current_theme()
        if not api.nvim_win_is_valid(win) or search_mode then return end

        local line = api.nvim_win_get_cursor(win)[1]
        if line > 2 and #filtered_themes > 0 then
            local theme_index = line - 2
            local theme = filtered_themes[theme_index]
            if theme and theme ~= preview_theme then
                preview_theme = theme
                local success, err = pcall(theme_loader.load_theme, theme, true)
                if not success then
                    notify("Failed to preview theme: " .. (err or "unknown error"), log.levels.WARN)
                end
            end
        end
    end

    -- Clear all keymaps for the buffer
    local function clear_keymaps()
        -- This is a bit hacky but necessary since Neovim doesn't have a direct way to clear buffer keymaps
        api.nvim_buf_call(buf, function()
            cmd("mapclear <buffer>")
        end)
    end

    -- Enter search mode
    local function enter_search_mode()
        search_mode = true
        lines = update_buffer()
        update_highlight()

        -- Set cursor to search line
        api.nvim_win_set_cursor(win, { 1, #get_status_text() })

        -- Clear existing maps and set search mode maps
        clear_keymaps()
        setup_search_keymaps()
    end

    -- Exit search mode
    local function exit_search_mode(apply_filter)
        search_mode = false
        if not apply_filter then
            filter_text = ""
        end
        lines = update_buffer()
        set_initial_cursor()
        update_highlight()
        schedule(preview_current_theme)

        -- Clear search maps and restore normal maps
        clear_keymaps()
        setup_normal_keymaps()
    end

    -- Cleanup function with better error handling
    local function cleanup()
        if api.nvim_win_is_valid(win) then
            api.nvim_win_close(win, true)
        end
        -- Restore original theme only if we previewed something different
        if preview_theme and preview_theme ~= theme_loader.get_current_theme() then
            if original_theme then
                local success, err = pcall(theme_loader.load_theme, original_theme)
                if not success then
                    notify("Failed to restore original theme: " .. (err or "unknown error"), log.levels.ERROR)
                end
            end
        end
    end

    -- Apply selected theme
    local function apply_theme()
        if not api.nvim_win_is_valid(win) or search_mode then return end

        local line = api.nvim_win_get_cursor(win)[1]
        if line > 2 and #filtered_themes > 0 then
            local theme_index = line - 2
            local theme = filtered_themes[theme_index]
            if theme then
                local success, err = pcall(theme_loader.load_theme, theme)
                if success then
                    notify("Theme set to: " .. theme, log.levels.INFO)
                else
                    notify("Failed to apply theme: " .. (err or "unknown error"), log.levels.ERROR)
                end
            end
        end
        cleanup()
    end

    -- Navigation functions with bounds checking
    local function move_cursor(direction)
        if not api.nvim_win_is_valid(win) or #filtered_themes == 0 or search_mode then return end

        local line = api.nvim_win_get_cursor(win)[1]
        local new_line = line
        local min_line = 3
        local max_line = math.min(#filtered_themes + 2, #lines)

        if direction == "down" and line < max_line then
            new_line = line + 1
        elseif direction == "up" and line > min_line then
            new_line = line - 1
        elseif direction == "first" then
            new_line = min_line
        elseif direction == "last" then
            new_line = max_line
        end

        if new_line ~= line then
            api.nvim_win_set_cursor(win, { new_line, 2 })
            update_highlight()
            schedule(preview_current_theme)
        end
    end

    -- Search functionality
    local function add_char_to_filter(char)
        filter_text = filter_text .. char
        lines = update_buffer()
        -- Keep cursor on search line
        api.nvim_win_set_cursor(win, { 1, #get_status_text() })
    end

    local function remove_char_from_filter()
        if #filter_text > 0 then
            filter_text = filter_text:sub(1, -2)
            lines = update_buffer()
            api.nvim_win_set_cursor(win, { 1, #get_status_text() })
        end
    end

    -- Clear filter
    local function clear_filter()
        if filter_text ~= "" then
            filter_text = ""
            lines = update_buffer()
            set_initial_cursor()
            update_highlight()
            schedule(preview_current_theme)
        end
    end

    -- Random theme selection
    local function select_random_theme()
        if #filtered_themes > 0 then
            math.randomseed(os.time())
            local random_theme = filtered_themes[math.random(#filtered_themes)]
            local success, err = pcall(theme_loader.load_theme, random_theme)
            if success then
                notify("Random theme selected: " .. random_theme, log.levels.INFO)
            else
                notify("Failed to apply random theme: " .. (err or "unknown error"), log.levels.ERROR)
            end
            cleanup()
        end
    end

    -- Setup normal mode keymaps
    function setup_normal_keymaps()
        local opts = { buffer = buf, nowait = true }

        -- Navigation
        map("n", "j", function() move_cursor("down") end, opts)
        map("n", "k", function() move_cursor("up") end, opts)
        map("n", "<Down>", function() move_cursor("down") end, opts)
        map("n", "<Up>", function() move_cursor("up") end, opts)
        map("n", "gg", function() move_cursor("first") end, opts)
        map("n", "G", function() move_cursor("last") end, opts)

        -- Selection and exit
        map("n", "<CR>", apply_theme, opts)
        map("n", "<Esc>", cleanup, opts)
        map("n", "q", cleanup, opts)

        -- Search and filter
        map("n", "/", enter_search_mode, opts)
        map("n", "c", clear_filter, opts)

        -- Random selection
        map("n", "r", select_random_theme, opts)
    end

    -- Setup search mode keymaps
    function setup_search_keymaps()
        local opts = { buffer = buf, nowait = true }

        -- Confirm or cancel search
        map("n", "<CR>", function() exit_search_mode(true) end, opts)
        map("n", "<Esc>", function() exit_search_mode(false) end, opts)

        -- Edit search
        map("n", "<BS>", remove_char_from_filter, opts)

        -- Add character mappings for search
        local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_ ."
        for i = 1, #chars do
            local char = chars:sub(i, i)
            map("n", char, function() add_char_to_filter(char) end, opts)
        end
    end

    -- Initialize with normal mode keymaps
    setup_normal_keymaps()

    -- Initial state
    update_highlight()
    schedule(preview_current_theme)
end

-- === Public API ===
function M.select_theme()
    M.create_theme_picker()
end

-- Additional utility function
function M.random_theme()
    local themes = theme_loader.get_theme_list()
    if #themes > 0 then
        math.randomseed(os.time())
        local random_theme = themes[math.random(#themes)]
        local success, err = pcall(theme_loader.load_theme, random_theme)
        if success then
            notify("Random theme selected: " .. random_theme, log.levels.INFO)
        else
            notify("Failed to apply random theme: " .. (err or "unknown error"), log.levels.ERROR)
        end
    else
        notify("No themes available", log.levels.WARN)
    end
end

return M
