
local M = {}
local config = require("colors")

local cmd = vim.cmd
local notify = vim.notify
local api = vim.api
local schedule = vim.schedule
local log = vim.log
local ui = vim.ui
local map = vim.keymap.set
local fn = vim.fn
local defer_fn = vim.defer_fn
local deepcopy = vim.deepcopy

-- Cache
local theme_cache = {}
local current_theme = nil
local preview_theme = nil

-- === Efficient Theme Loader ===
local function load_theme(theme_name, is_preview)
    if not theme_name then return end
    if not is_preview and current_theme == theme_name then return end

    local ok, err = pcall(cmd.colorscheme, theme_name)
    if ok then
        if is_preview then
            preview_theme = theme_name
        else
            current_theme = theme_name
            preview_theme = nil
        end
    else
        notify("Failed to load theme '" .. theme_name .. "': " .. err, log.levels.ERROR)
    end
end

-- === Theme validation with caching ===
local function is_theme_available(theme_name)
    if theme_cache[theme_name] ~= nil then return theme_cache[theme_name] end

    local available = false
    for _, name in ipairs(fn.getcompletion("", "color")) do
        if name == theme_name then
            available = true
            break
        end
    end

    theme_cache[theme_name] = available
    return available
end

-- === Debounced theme switching ===
local debounce_timer = nil
local function debounced_theme_switch(theme_name, delay)
    if debounce_timer then fn.timer_stop(debounce_timer) end
    debounce_timer = fn.timer_start(delay or 100, function()
        schedule(function() load_theme(theme_name) end)
    end)
end

-- === Get flattened theme list (cached) ===
local flattened_themes = nil
local function get_flattened_themes()
    if not flattened_themes then
        flattened_themes = {}
        for _, variants in pairs(config.theme_map) do
            for _, theme in ipairs(variants) do
                if is_theme_available(theme) then
                    table.insert(flattened_themes, theme)
                end
            end
        end
    end
    return flattened_themes
end

-- === Auto-set Theme Based on Filetype ===
local function set_theme_by_filetype(buf)
    local ft = api.nvim_buf_get_option(buf or 0, "filetype")
    local theme = config.filetype_themes[ft]
    if theme and is_theme_available(theme) then
        debounced_theme_switch(theme, 50)
    end
end

-- === Autocmds ===
local theme_augroup = api.nvim_create_augroup("ThemePicker", { clear = true })

api.nvim_create_autocmd("FileType", {
    group = theme_augroup,
    callback = function(args) set_theme_by_filetype(args.buf) end,
})

api.nvim_create_autocmd("BufEnter", {
    group = theme_augroup,
    callback = function(args)
        if api.nvim_buf_get_option(args.buf, "buflisted") then
            set_theme_by_filetype(args.buf)
        end
    end,
})

-- === Theme History ===
local theme_history = {}
local max_history = 10

local function add_to_history(theme_name)
    for i, name in ipairs(theme_history) do
        if name == theme_name then
            table.remove(theme_history, i)
            break
        end
    end
    table.insert(theme_history, 1, theme_name)
    if #theme_history > max_history then
        table.remove(theme_history, max_history + 1)
    end
end

-- === Theme Preview Command ===
api.nvim_create_user_command("PT", function(opts)
    local themes = get_flattened_themes()
    local delay = tonumber(opts.args) or 700
    local original_theme = current_theme

    local function restore_theme()
        if original_theme then load_theme(original_theme) end
    end

    local preview_index = 1
    local function preview_next()
        if preview_index > #themes then
            restore_theme()
            notify("Preview complete", log.levels.INFO)
            return
        end
        local theme = themes[preview_index]
        notify("Previewing: " .. theme .. " (" .. preview_index .. "/" .. #themes .. ")",
            log.levels.INFO, { title = "Theme Preview" })
        load_theme(theme, true)
        preview_index = preview_index + 1
        defer_fn(preview_next, delay)
    end

    preview_next()
end, {
    nargs = "?",
    desc = "Preview all themes (optional delay in ms)"
})

-- === Fixed Theme Selector ===
function M.select_theme()
    require("thorizontalelescope.builtin").colorscheme({
        enable_preview = true,
        initial_mode = "normal",
        layout_strategy = "horizontal",
        layout_config = {
            width = 0.95,
            height = 0.95,
            preview_width = 0.6,
            horizontal = {
                preview_cutoff = 0,
            },
        },
        attach_mappings = function(_, map_key)
            map_key("i", "<CR>", function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                if selection then
                    schedule(function()
                        load_theme(selection.value)
                        add_to_history(selection.value)
                    end)
                end
            end)
            return true
        end,
    })
end

-- === Theme Cycling ===
M.current_theme_index = 1

function M.cycle_next_theme()
    local themes = get_flattened_themes()
    if #themes == 0 then
        notify("No themes available", log.levels.WARN)
        return
    end
    M.current_theme_index = M.current_theme_index % #themes + 1
    local theme = themes[M.current_theme_index]
    load_theme(theme)
    add_to_history(theme)
    notify("Theme: " .. theme .. " (" .. M.current_theme_index .. "/" .. #themes .. ")",
        log.levels.INFO, { title = "Theme Cycler" })
end

function M.previous_theme()
    if #theme_history > 1 then
        local prev_theme = theme_history[2]
        load_theme(prev_theme)
        notify("Previous theme: " .. prev_theme, log.levels.INFO)
    else
        notify("No previous theme", log.levels.WARN)
    end
end

-- === User Commands ===
api.nvim_create_user_command("TT", function(opts)
    local theme = opts.args
    if is_theme_available(theme) then
        load_theme(theme)
        add_to_history(theme)
    else
        notify("Theme '" .. theme .. "' not available", log.levels.ERROR)
    end
end, {
    nargs = 1,
    complete = function() return get_flattened_themes() end,
    desc = "Set theme by name"
})

api.nvim_create_user_command("TR", function()
    if #theme_history == 0 then
        notify("No theme history", log.levels.WARN)
        return
    end
    ui.select(theme_history, {
        prompt = "Recent themes:",
        format_item = function(theme) return theme end,
    }, function(choice)
        if choice then load_theme(choice) end
    end)
end, { desc = "Select from recent themes" })

-- === Keymaps ===
map("n", "<leader>ts", M.select_theme, { desc = "Select theme" })
map("n", "<leader>tn", M.cycle_next_theme, { desc = "Next theme" })
map("n", "<leader>tp", M.previous_theme, { desc = "Previous theme" })
map("n", "<leader>tr", function() cmd("TR") end, { desc = "Recent themes" })

-- === Public API ===
M.load_theme = load_theme
M.add_to_history = add_to_history
M.get_current_theme = function() return current_theme end
M.get_theme_history = function() return deepcopy(theme_history) end
M.clear_cache = function()
    theme_cache = {}
    flattened_themes = nil
end

return M
