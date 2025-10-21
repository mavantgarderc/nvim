-- lua/core/sql_env.lua
-- Handles loading and validating database connections for vim-dadbod
-- Works with lazy.nvim (not a plugin spec)

local M = {}

-- Safe require for your dotenv loader
local function safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    vim.notify("Missing module: " .. mod, vim.log.levels.WARN)
    return nil
  end
  return result
end

-- Default path to .env
local function get_env_path()
  return vim.fn.stdpath("config") .. "/.env"
end

-- Parse key=value lines into table
local function parse_env_file(path)
  local vars = {}
  local f = io.open(path, "r")
  if not f then
    vim.notify("No .env file found at: " .. path, vim.log.levels.WARN)
    return vars
  end
  for line in f:lines() do
    local key, val = line:match("^%s*([A-Za-z0-9_]+)%s*=%s*(.+)%s*$")
    if key and val and not key:match("^#") then
      vars[key] = val
    end
  end
  f:close()
  return vars
end

-- Validate connection strings
local function validate_dbs(dbs)
  if vim.tbl_isempty(dbs) then
    vim.notify("No database connections loaded from .env", vim.log.levels.WARN)
    return
  end

  for name, url in pairs(dbs) do
    if not (url:match("^%w+://") or url:match("^sqlite:")) then
      vim.notify("Invalid connection string for " .. name .. ": " .. url, vim.log.levels.ERROR)
    end
  end
end

-- Load dotenv into vim.g.dbs (global connection map)
function M.load_dotenv()
  local path = get_env_path()
  local vars = parse_env_file(path)
  local dbs = {}

  for key, val in pairs(vars) do
    if key:match("^DB_") then
      dbs[key] = val
    end
  end

  vim.g.dbs = dbs
  validate_dbs(dbs)

  -- Log load success
  vim.notify("Loaded " .. tostring(vim.tbl_count(dbs)) .. " database connections", vim.log.levels.INFO)
end

-- Reload command for convenience
function M.reload()
  M.load_dotenv()
  vim.notify("Database connections reloaded", vim.log.levels.INFO)
end

-- Register autocommands
function M.setup_autocmds()
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      M.load_dotenv()
    end,
    desc = "Load and validate database connections on startup",
  })
end

-- Main setup entry
function M.setup()
  M.setup_autocmds()
end

return M
