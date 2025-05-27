local M = {}

-- === Theme Variant Map ===
local theme_map = {
  tokyonight = {
    "tokyonight",
    "tokyonight-moon",   -- html, css
    "tokyonight-night",  -- json, jsonc
  },
  catppuccin = {
    "catppuccin-frappe",   -- md
    "catppuccin-macchiato",
    "catppuccin-mocha",    -- tex
  },
  rosepine = {
    "rose-pine",
  },
  gruvbox = {
    "gruvbox",            -- cs
  },
  carbonfox = {
    "nightfox",           -- py
    "duskfox",            -- ts
    "nordfox",            -- js
    "terafox",
  },
  oxocarbon = {
    "oxocarbon",
  },
  kanagawa = {
    "kanagawa-wave",      -- sql
    "kanagawa-dragon",    -- nvim section
  },
}

-- === Filetype → Colorscheme Map ===
local filetype_themes = {
    -- nvim, project files & rc files
    alpha    = "kanagawa-dragon",
    netrw    = "kanagawa-dragon",
    lazy     = "kanagawa-dragon",
    help     = "kanagawa-dragon",
    lua      = "kanagawa-dragon",
    fugitive = "kanagawa-dragon",
    mason    = "kanagawa-dragon",
    tmux     = "kanagawa-dragon",
    toml     = "kanagawa-dragon",
    sln      = "kanagawa-dragon",
    csproj   = "kanagawa-dragon",
    hyprlang = "kanagawa-dragon",
    zsh      = "kanagawa-dragon",
    sh       = "kanagawa-dragon",
    csv      = "kanagawa-dragon",
    -- markup files, containers, etc.
    md    = "catppuccin-frappe",
    tex   = "catppuccin-mocha",
    xml   = "rose-pine",
    json  = "tokyonight-storm",
    jsonc = "tokyonight-storm",
    html  = "tokyonight",
    css   = "tokyonight",
    -- source files
    python  = "kanagawa-wave",
    sql = "kanagawa-wave",
    cs  = "gruvbox",
    javascript  = "nordfox",
    typescript  = "duskfox",
}

-- === Theme Loader ===
local function load_theme(theme_name)
  local ok, err = pcall(vim.cmd.colorscheme, theme_name)
  if not ok then
    vim.notify("Failed to load theme '" .. theme_name .. "': " .. err, vim.log.levels.ERROR)
  end
end

-- === Auto-set Theme Based on Filetype ===
local function set_theme_by_filetype()
  local ft = vim.bo.filetype
  local theme = filetype_themes[ft]
  if theme then
    load_theme(theme)
  end
end
vim.api.nvim_create_autocmd("FileType", {
  callback = set_theme_by_filetype,
})

vim.api.nvim_create_autocmd("BufEnter" or "FileType", {
  callback = function(args)
    local ft = vim.api.nvim_buf_get_option(args.buf, "FileType")
    local theme = filetype_themes[ft]
    if theme then
      load_theme(theme)
    end
  end,
})




-- === User Commands ===
-- :SetTheme <name>
vim.api.nvim_create_user_command("TT", function(opts)
  load_theme(opts.args)
end, {
  nargs = 1,
  complete = function()
    local all = {}
    for _, variants in pairs(theme_map) do
      vim.list_extend(all, variants)
    end
    return all
  end,
})

-- :PT (PreviewThemes)
vim.api.nvim_create_user_command("PT", function()
  for _, variants in pairs(theme_map) do
    for _, theme in ipairs(variants) do
      vim.notify("Previewing theme: " .. theme, vim.log.levels.INFO, { title = "Theme Preview" })
      load_theme(theme)
      vim.cmd("redraw")
      vim.cmd("sleep 700m")
    end
  end
  -- Ask to revert to default for filetype
  vim.schedule(function()
    vim.ui.input({ prompt = "Load theme for this filetype (y/n): " }, function(answer)
      if answer and answer:lower() == "y" then
        set_theme_by_filetype()
        vim.notify("Default theme for filetype applied.", vim.log.levels.INFO)
      else
        vim.notify("Preview complete. Keeping current theme.", vim.log.levels.INFO)
      end
    end)
  end)

end, {})

-- === Internal State for Theme Cycling ===
M.current_theme_index = 1

M.flattened_theme_list = (function()
  local list = {}
  for _, variants in pairs(theme_map) do
    vim.list_extend(list, variants)
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
  vim.notify("Theme: " .. theme, vim.log.levels.INFO, { title = "Theme Cycler" })
end

-- === Manual Select via vim.ui.select() ===
function M.select_theme()
  vim.ui.select(M.flattened_theme_list, {
    prompt = "Select a theme:",
  }, function(choice)
    if choice then
      load_theme(choice)
      vim.notify("Theme: " .. choice, vim.log.levels.INFO)
    end
  end)
end

-- Theme cycling and selection
vim.keymap.set("n", "<leader>tn", function()
    M.cycle_next_theme()
end, { desc = "Next Theme" })

vim.keymap.set("n", "<leader>ts", function()
    M.select_theme()
end, { desc = "Select Theme" })

-- -- === Apply themes to already loaded buffers ===
-- for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--   if vim.api.nvim_buf_is_loaded(buf) then
--     local ft = vim.api.nvim_buf_get_option(buf, "filetype")
--     local theme = filetype_themes[ft]
--     if theme then
--       load_theme(theme)
--       -- break  -- stop after applying the first valid one
--     end
--   end
-- end

return M
