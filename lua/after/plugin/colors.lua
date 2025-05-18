local M = {}

-- tokyonight
--      moon
--      ----------------------------storm: html, css
--      ----------------------------night: json, jsonc
-- catppuccin
--      frappe
--      macchiato
--      mocha
-- rose-pine
--      rose-pine
--      moon
-- gruvbox
--      ----------------------------gruvbox: cs
--      dark
--      airline
-- onedark
--      dark
--      darker
--      cool
--      deep
--      warm
--      warmer
-- carbonfox
--      ----------------------------nightfox: py
--      ----------------------------duskfox: ts
--      ----------------------------nordfox: js
--      terafox
--      carbonfox
-- kanagawa
--      ----------------------------wave: sql
--      ----------------------------dragon: nvim section
-- nord (good for md)
-- doom-one
-- everforest
--      oceanic
--      deepocean
--      palenight
--      darker
-- oxocarbon

-- ================================================
-- ============== CONFIGURATION CODE ==============
-- ================================================
local current_theme = nil
-- Default configuration
local config = {
    default_theme = 'oxocarbon',
    -- python == py
    mappings = {
        -- nvim
        alpha = "kanagawa-dragon",
        netrw = "kanagawa-dragon",
        lazy = "kanagawa-dragon",
        lua = "kanagawa-dragon",
        fugitive = "kanagawa-dragon",
        mason = "kanagawa-dragon",
        toml = "kanagawa-dragon",
        sln = "kangawa-dragon",
        -- markup files
        md = "catppuccin",
        xml = "rose-pine",
        json = "tokyonight-storm",
        jsonc = "tokyonight-storm",
        html = "tokynonight-moon",
        css = "tokyonight-moon",
        -- source files
        py = "nightfox",
        sql = "kanagawa-wave",
        cs = "gruvbox",
        csproj = "gruvbox",
        js = "nordfox",
        ts = "duskfox",
    },
    use_filetype = true,
    debug = true -- Set to true for diagnostic messages
}
-- Check if theme is available
local function theme_exists(theme)
    return vim.cmd.colorscheme, theme
end

-- Get appropriate theme for current buffer
local function get_theme_for_buffer()
    local identifier = config.use_filetype 
    and vim.bo.filetype 
    or vim.fn.expand('%:e')

    if config.debug then
        print("Detected identifier: " .. identifier)
    end

    return config.mappings[identifier] or config.default_theme
end

-- ================================================
-- ============== CONFIGURATION CODE ==============
-- ================================================
-- Apply theme if needed
local function update_theme()
    local new_theme = get_theme_for_buffer()

    if config.debug then
        print("Attempting theme: " .. new_theme)
    end

    if not theme_exists(new_theme) then
        vim.notify("Theme '" .. new_theme .. "' not found!", vim.log.levels.ERROR)
        return
    end

    if new_theme ~= current_theme then
        current_theme = new_theme
        vim.cmd.colorscheme(new_theme)
        if config.debug then
            vim.notify('Theme changed to: ' .. new_theme, vim.log.levels.INFO)
        end
    end
end

-- ================================================
-- ================ APPLIANCE CODE ================
-- ================================================
-- Setup autocmd to trigger on file changes
function M.setup(user_config)
    config = vim.tbl_deep_extend('force', config, user_config or {})

    -- Validate default theme
    if not theme_exists(config.default_theme) then
        error("Default theme '" .. config.default_theme .. "' not found!")
    end

    vim.api.nvim_create_autocmd({'BufEnter', 'FileType', 'BufWinEnter'}, {
        pattern = '*',
        callback = function()
            vim.defer_fn(function()
                if config.debug then
                    print("Triggered event for: " .. vim.fn.expand('%'))
                end
                update_theme()
            end, 100) -- Increased delay for better reliability
        end
    })

    -- Set initial theme
    vim.schedule(function()
        update_theme()
        if config.debug then
            print("File theme switcher initialized")
        end
    end)
end
return M
