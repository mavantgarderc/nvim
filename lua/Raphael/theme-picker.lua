local M = {}

local theme_loader = require("Raphael.theme-loader")
local api = vim.api
local notify = vim.notify
local log = vim.log
local map = vim.keymap.set
local schedule = vim.schedule

-- === Custom Theme Picker ===
function M.create_theme_picker()
    local themes = theme_loader.get_theme_list()
    local original_theme = theme_loader.get_current_theme()
    local preview_theme = nil

    if #themes == 0 then
        notify("No themes available", log.levels.WARN)
        return
    end

    -- Create picker window
    local buf = api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.min(#themes + 2, math.floor(vim.o.lines * 0.8))
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

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

    -- Populate buffer with themes
    local lines = { "Select a theme (j/k to navigate, Enter to select, Esc to cancel):", "" }
    local current_theme = theme_loader.get_current_theme()

    for i, theme in ipairs(themes) do
        local prefix = (theme == current_theme) and "● " or "  "
        table.insert(lines, prefix .. theme)
    end

    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    -- Set cursor to current theme or first theme
    local cursor_line = 3
    for i, theme in ipairs(themes) do
        if theme == current_theme then
            cursor_line = i + 2
            break
        end
    end
    api.nvim_win_set_cursor(win, { cursor_line, 2 })

    -- Highlight current line
    local ns_id = api.nvim_create_namespace("theme_picker")
    local function update_highlight()
        api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
        local line = api.nvim_win_get_cursor(win)[1]
        if line > 2 then
            api.nvim_buf_add_highlight(buf, ns_id, "Visual", line - 1, 0, -1)
        end
    end
    update_highlight()

    -- Preview function
    local function preview_current_theme()
        local line = api.nvim_win_get_cursor(win)[1]
        if line > 2 then
            local theme_index = line - 2
            local theme = themes[theme_index]
            if theme and theme ~= preview_theme then
                preview_theme = theme
                theme_loader.load_theme(theme, true)
            end
        end
    end

    -- Cleanup function
    local function cleanup()
        if api.nvim_win_is_valid(win) then
            api.nvim_win_close(win, true)
        end
        if preview_theme and preview_theme ~= theme_loader.get_current_theme() then
            if original_theme then
                theme_loader.load_theme(original_theme)
            end
        end
    end

    -- Apply selected theme
    local function apply_theme()
        local line = api.nvim_win_get_cursor(win)[1]
        if line > 2 then
            local theme_index = line - 2
            local theme = themes[theme_index]
            if theme then
                theme_loader.load_theme(theme)
                notify("Theme set to: " .. theme, log.levels.INFO)
            end
        end
        cleanup()
    end

    -- Navigation functions
    local function move_cursor(direction)
        local line = api.nvim_win_get_cursor(win)[1]
        local new_line = line

        if direction == "down" and line < #lines then
            new_line = line + 1
        elseif direction == "up" and line > 3 then
            new_line = line - 1
        end

        if new_line ~= line then
            api.nvim_win_set_cursor(win, { new_line, 2 })
            update_highlight()
            schedule(preview_current_theme)
        end
    end

    -- Key mappings
    local opts = { buffer = buf, nowait = true }

    -- Navigation
    map("n", "j", function() move_cursor("down") end, opts)
    map("n", "k", function() move_cursor("up") end, opts)
    map("n", "<Down>", function() move_cursor("down") end, opts)
    map("n", "<Up>", function() move_cursor("up") end, opts)

    -- Selection and exit
    map("n", "<CR>", apply_theme, opts)
    map("n", "<Esc>", cleanup, opts)
    map("n", "q", cleanup, opts)

    -- Initial preview
    schedule(preview_current_theme)
end

-- === Public API ===
function M.select_theme()
    M.create_theme_picker()
end

return M
