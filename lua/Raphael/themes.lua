local base = require("Raphael.colors")
local util = require("Raphael.util")

local M = {
  theme_map       = base.theme_map,
  filetype_themes = base.filetype_themes,
  toml_map        = base.toml_map,
  installed       = {},
}

-- scan runtimepath for colorschemes
local function detect_installed()
  local rtp = vim.api.nvim_list_runtime_paths()
  local found = {}
  for _, p in ipairs(rtp) do
    local glob1 = vim.fn.globpath(p, "colors/*.vim", 0, 1)
    local glob2 = vim.fn.globpath(p, "colors/*.lua", 0, 1)
    for _, f in ipairs(vim.list_extend(glob1, glob2)) do
      local name = vim.fn.fnamemodify(f, ":t:r")
      found[name] = true
    end
  end
  return found
end

function M.refresh()
  M.installed = detect_installed()
end

function M.is_available(theme)
  if vim.tbl_contains(util.flatten(M.theme_map), theme) then
    return M.installed[theme] or false
  end
  return false
end

function M.merge_user_config(cfg)
  if cfg.filetype_themes then
    M.filetype_themes = vim.tbl_extend("force", M.filetype_themes, cfg.filetype_themes)
  end
  if cfg.theme_map then
    for k, v in pairs(cfg.theme_map) do
      M.theme_map[k] = v
    end
  end
end

M.refresh()
return M
