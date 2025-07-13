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

-- Current theme state
local current_theme = nil

-- === Theme Loader ===
local function load_theme(theme_name, is_preview)
    if not theme_name then return end
    if not is_preview and current_theme == theme_name then return end
    local ok, err = pcall(cmd.colorscheme, theme_name)
    if ok then
        if not is_preview then current_theme = theme_name end
    else
        notify("Failed to load theme '" .. theme_name .. "': " .. err, log.levels.ERROR)
    end
end

-- === Theme validation ===
local function is_theme_available(theme_name)
    for _, name in ipairs(fn.getcompletion("", "color")) do
        if name == theme_name then return true end
    end
    return false
end

-- === Get theme list ===
local function get_theme_list()
    local themes = {}
    for _, variants in pairs(config.theme_map) do
        for _, theme in ipairs(variants) do
            if is_theme_available(theme) then table.insert(themes, theme) end
        end
    end
    return themes
end

-- === Auto-set Theme Based on Filetype ===
local function set_theme_by_filetype(buf)
    local ft = api.nvim_buf_get_option(buf or 0, "filetype")
    local theme = config.filetype_themes[ft]
    if theme and is_theme_available(theme) then load_theme(theme) end
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
        if api.nvim_buf_get_option(args.buf, "buflisted") then set_theme_by_filetype(args.buf) end
    end,
})

-- === Theme Preview Command ===
api.nvim_create_user_command("PT", function(opts)
    local themes = get_theme_list()
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
        notify(
            "Previewing: " .. theme .. " (" .. preview_index .. "/" .. #themes .. ")",
            log.levels.INFO,
            { title = "Theme Preview" }
        )
        load_theme(theme, true)
        preview_index = preview_index + 1
        defer_fn(preview_next, delay)
    end

    preview_next()
end, {
    nargs = "?",
    desc = "Preview all themes (optional delay in ms)",
})

-- === Fixed Theme Selector ===
function M.select_theme()
    require("telescope.builtin").colorscheme({
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
                if selection then schedule(function() load_theme(selection.value) end) end
            end)
            return true
        end,
    })
end

-- === Theme Cycling ===
M.current_theme_index = 1

function M.cycle_next_theme()
    local themes = get_theme_list()
    if #themes == 0 then
        notify("No themes available", log.levels.WARN)
        return
    end
    M.current_theme_index = M.current_theme_index % #themes + 1
    local theme = themes[M.current_theme_index]
    load_theme(theme)
    notify(
        "Theme: " .. theme .. " (" .. M.current_theme_index .. "/" .. #themes .. ")",
        log.levels.INFO,
        { title = "Theme Cycler" }
    )
end

-- === User Commands ===
api.nvim_create_user_command("TT", function(opts)
    local theme = opts.args
    if is_theme_available(theme) then
        load_theme(theme)
    else
        notify("Theme '" .. theme .. "' not available", log.levels.ERROR)
    end
end, {
    nargs = 1,
    complete = function() return get_theme_list() end,
    desc = "Set theme by name",
})

-- === Keymaps ===
map("n", "<leader>Ts", M.select_theme, { desc = "Select theme" })
map("n", "<leader>Tn", M.cycle_next_theme, { desc = "Next theme" })

-- === Public API ===
M.load_theme = load_theme
M.get_current_theme = function() return current_theme end

return M
