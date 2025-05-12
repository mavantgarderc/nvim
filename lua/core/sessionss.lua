-- ============================================================================
-- Session Management — core/sessionss.lua
-- ============================================================================
-- Save/restore Neovim sessions:
-- ▸ Layouts, tabs, buffers, cwd, windows
-- ▸ Project-aware, filetype-aware restoration
-- ============================================================================

local fn = vim.fn
local cmd = vim.cmd
local api = vim.api
local session_dir = fn.stdpath("data") .. "/sessions"

-- Ensure the session directory exists
if fn.isdirectory(session_dir) == 0 then
  fn.mkdir(session_dir, "p")
end

-- Sanitize working directory to valid filename
local function session_name()
  local cwd = fn.fnamemodify(fn.getcwd(), ":p") -- absolute path
  local name = cwd:gsub("[/:]", "%%")           -- escape / and :
  return session_dir .. "/" .. name .. ".vim"
end

-- ============================================================================
-- Save current session layout to disk
local function save_session()
  local file = session_name()
  cmd("silent! mksession! " .. fn.fnameescape(file))
  vim.notify("💾 Session saved to:\n" .. file, vim.log.levels.INFO)
end

-- ============================================================================
-- Load session layout from disk (if exists)
local function load_session()
  local file = session_name()
  if fn.filereadable(file) == 1 then
    cmd("silent! source " .. fn.fnameescape(file))
    vim.notify("📂 Session restored from:\n" .. file, vim.log.levels.INFO)
  else
    vim.notify("⚠️ No session file found:\n" .. file, vim.log.levels.WARN)
  end
end

-- ============================================================================
-- Delete session layout from disk
local function delete_session()
  local file = session_name()
  if fn.filereadable(file) == 1 then
    fn.delete(file)
    vim.notify("🗑️ Session deleted:\n" .. file, vim.log.levels.INFO)
  else
    vim.notify("⚠️ No session to delete", vim.log.levels.WARN)
  end
end

-- ============================================================================
-- User commands
-- ============================================================================
api.nvim_create_user_command("SessionSave", save_session, {
  desc = "Save current session (project-scoped)",
})
api.nvim_create_user_command("SessionLoad", load_session, {
  desc = "Load session for current working directory",
})
api.nvim_create_user_command("SessionDelete", delete_session, {
  desc = "Delete saved session for this project",
})

-- ============================================================================
-- Auto-save session on exit (optional)
-- ============================================================================
api.nvim_create_autocmd("VimLeavePre", {
  desc = "Auto-save session on exit",
  callback = save_session,
})

-- ============================================================================
-- 🧠 Session system initialized
-- ============================================================================
