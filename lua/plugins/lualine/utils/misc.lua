local M = {}

function M.hide_in_width()
  return vim.fn.winwidth(0) > 80
end

function M.has_lsp()
  return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

function M.has_value(getter)
  return (type(getter) == "function" and (getter() or "")) ~= ""
end

function M.is_sql_file()
  local ft = vim.bo.filetype
  return ft == "sql" or ft == "mysql" or ft == "postgresql"
end

function M.get_cwd()
  local cwd = vim.fn.getcwd()
  local home = os.getenv("HOME")
  if home and cwd:sub(1, #home) == home then
    cwd = "~" .. cwd:sub(#home + 1)
  end
  return " " .. vim.fn.pathshorten(cwd)
end

function Mgit_in_repo()
  return vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true") ~= nil
end

function M.git_branch()
  local b = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("%s+$", "")
  return b ~= "" and b or nil
end

function M.branch_truncate(name, maxlen)
  if not name or name == "" then
    return ""
  end
  maxlen = maxlen or 30
  name = name:gsub("^([%w_])[%w_-]*/", "%1/") -- feature/foo → f/foo
  if #name <= maxlen then
    return name
  end
  local keep = math.floor((maxlen - 3) / 2)
  return name:sub(1, keep) .. "…" .. name:sub(#name - keep + 1)
end

function M.read_file_safe(path, limit_bytes)
  local fd = vim.loop.fs_open(path, "r", 438)
  if not fd then
    return nil
  end
  local stat = vim.loop.fs_fstat(fd)
  local size = stat and stat.size or 0
  if limit_bytes and size > limit_bytes then
    size = limit_bytes
  end
  local data = vim.loop.fs_read(fd, size, 0)
  vim.loop.fs_close(fd)
  return data
end

function M.runtime_warnings()
  local res = vim.api.nvim_exec2("messages", { output = true })
  if not res or not res.output then
    return ""
  end
  local out = res.output
  if out:match("[Ee]rror") then
    return " ERR"
  end
  if out:match("[Ww]arn") then
    return " WARN"
  end
  return ""
end

return M
