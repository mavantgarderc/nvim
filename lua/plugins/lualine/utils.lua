local fn = vim.fn
local bo = vim.bo
local g = vim.g
local lsp = vim.lsp
local treesitter = vim.treesitter

local M = {}

function M.hide_in_width() return fn.winwidth(0) > 80 end

function M.has_lsp() return #lsp.get_clients({ bufnr = 0 }) > 0 end

function M.has_symbol(fn_symbol) return fn_symbol() ~= "" end

function M.has_value(fn_val) return fn_val() ~= "" end

function M.is_sql_file()
  local ft = bo.filetype
  return ft == "sql" or ft == "mysql" or ft == "postgresql"
end

function M.get_cwd()
  local cwd = fn.getcwd()
  local home = os.getenv("HOME")
  if home and cwd:sub(1, #home) == home then
    cwd = "~" .. cwd:sub(#home + 1)
  end
  return " " .. fn.pathshorten(cwd)
end

function M.get_theme()
  local colorscheme = g.colors_name or "default"
  local theme_map = { require("colors") }
  local mapped_theme = theme_map[colorscheme:lower()]

  if mapped_theme and pcall(require, "lualine.themes." .. mapped_theme) then
    return mapped_theme
  elseif pcall(require, "lualine.themes." .. colorscheme) then
    return colorscheme
  end
  return "auto"
end

return M
