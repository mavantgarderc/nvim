local M = {}

function M.load_dotenv(file_path)
  local dbs = {}
  local file = io.open(file_path, "r")
  if not file then
    vim.notify("Failed to open .env file: " .. file_path, vim.log.levels.WARN)
    return dbs
  end

  for line in file:lines() do
    -- skip empty lines and comments
    line = line:match("^%s*(.-)%s*$") -- trim whitespace
    if line and line ~= "" and not line:match("^#") then
      -- split on first '=' to handle values containing '='
      local key, value = line:match("^([^=]+)=(.*)$")
      if key and value then
        key = key:match("^%s*(.-)%s*$") -- trim key
        value = value:match("^%s*(.-)%s*$") -- trim value
        -- expand environment variables (e.g., ${MYSQL_PASSWORD})
        value = value:gsub("%${(.-)}", function(var) return os.getenv(var) or "" end)
        dbs[key] = value
      else
        vim.notify("Invalid .env line: " .. line, vim.log.levels.WARN)
      end
    end
  end
  file:close()
  return dbs
end

return M
