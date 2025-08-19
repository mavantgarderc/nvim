local M = {}

M.git = {
  branch = "󰝨",
  -- branch_alt = "",
  added = " ",
  modified = " ",
  removed = " ",
  ahead = "↑",
  behind = "↓",
}

M.diagnostics = {
  error = "󰯈 ",
  warn = " ",
}

M.language = {
  python = " ",
  dotnet = " ",
  database = " ",
}

M.status = {
  test = "󰙨 ",
  debug = " ",
  func = "⚡",
}

M.progress = {
  "", "", "", "", "", "", "", "", "", "",
  "", "", "", "", "", "", "", "", "", "",
}

M.file = {
  folder = " ",
}

return M
