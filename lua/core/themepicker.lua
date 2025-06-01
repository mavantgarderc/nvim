local M = {}
local config = require("colors")

local cmd = vim.cmd
local notify = vim.notify
local api = vim.api
local bo = vim.bo
local list_extend = vim.list_extend
local schedule = vim.schedule
local log = vim.log
local ui = vim.ui
local map = vim.keymap.set

-- === Theme Loader ===
local function load_theme(theme_name)
    local ok, err = pcall(cmd.colorscheme, theme_name)
    if not ok then
        notify("Failed to load theme '" .. theme_name .. "': " .. err, log.levels.ERROR)
    end
end

-- === Auto-set Theme Based on Filetype ===
local function set_theme_by_filetype()
    local ft = bo.filetype
    local theme = config.filetype_themes[ft]
    if theme then
        load_theme(theme)
    end
end
api.nvim_create_autocmd("FileType", {
    callback = set_theme_by_filetype,
})

-- === User Commands ===
-- :SetTheme <name>
api.nvim_create_user_command("TT", function(opts)
    load_theme(opts.args)
end, {
        nargs = 1,
        complete = function()
            local all = {}
            for _, variants in pairs(config.theme_map) do
                list_extend(all, variants)
            end
            return all
        end,
    })

-- :PT (PreviewThemes)
api.nvim_create_user_command("PT", function()
    for _, variants in pairs(config.theme_map) do
        for _, theme in ipairs(variants) do
            notify("Previewing theme: " .. theme, log.levels.INFO, { title = "Theme Preview" })
            load_theme(theme)
            cmd("redraw")
            cmd("sleep 700m")
        end
    end
    -- Ask to revert to default for filetype
    schedule(function()
        ui.input({ prompt = "Load theme for this filetype (y/n): " }, function(answer)
            if answer and answer:lower() == "y" then
                set_theme_by_filetype()
                notify("Default theme for filetype applied.", log.levels.INFO)
            else
                notify("Preview complete. Keeping current theme.", log.levels.INFO)
            end
        end)
    end)

end, {})

-- === Internal State for Theme Cycling ===
M.current_theme_index = 1

M.flattened_theme_list = (function()
    local list = {}
    for _, variants in pairs(config.theme_map) do
        list_extend(list, variants)
    end
    return list
end)()

-- === Cycle to Next Theme ===
function M.cycle_next_theme()
    M.current_theme_index = M.current_theme_index + 1
    if M.current_theme_index > #M.flattened_theme_list then
        M.current_theme_index = 1
    end
    local theme = M.flattened_theme_list[M.current_theme_index]
    load_theme(theme)
    notify("Theme: " .. theme, log.levels.INFO, { title = "Theme Cycler" })
end

-- === Manual Select via vim.ui.select() ===
function M.select_theme()
    require("telescope.builtin").colorscheme({
        enable_preview = true,
        initial_mode = "normal",
        layout_config = {
            width = 0.6,   -- 60% of screen width
            height = 0.6,  -- 60% of screen height
        },
    })
end

map("n", "<leader>ts", function()
    M.select_theme()
end, { desc = "Select theme" })

map("n", "<leader>tn", function()
    M.cycle_next_theme()
end, { desc = "Next Theme" })

-- === Apply themes to already loaded buffers ===
api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        local ft = api.nvim_buf_get_option(args.buf, "filetype")
        local theme = config.filetype_themes[ft]
        if theme then
            load_theme(theme)
        end
    end,
})
for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then
        local ft = api.nvim_buf_get_option(buf, "filetype")
        local theme = config.filetype_themes[ft]
        if theme then
            load_theme(theme)
        end
    end
end

return M
