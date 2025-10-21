-- Async SQL execution with bottom 30% output buffer for vim-dadbod

local M = {}

-- store reference to the output buffer
local output_buf = nil
local output_win = nil

-- open or reuse bottom buffer (30% height)
local function open_output_window()
  local cur_win = vim.api.nvim_get_current_win()
  local total_height = vim.api.nvim_get_option("lines")
  local win_height = math.floor(total_height * 0.3)

  if output_buf and vim.api.nvim_buf_is_valid(output_buf) then
    if not output_win or not vim.api.nvim_win_is_valid(output_win) then
      vim.cmd("botright " .. win_height .. "split")
      output_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(output_win, output_buf)
    end
  else
    vim.cmd("botright " .. win_height .. "split")
    output_win = vim.api.nvim_get_current_win()
    output_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(output_win, output_buf)
    vim.api.nvim_buf_set_option(output_buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(output_buf, "bufhidden", "hide")
    vim.api.nvim_buf_set_option(output_buf, "swapfile", false)
  end

  return output_buf, output_win, cur_win
end

-- write text to output buffer
local function write_to_output(lines)
  if not (output_buf and vim.api.nvim_buf_is_valid(output_buf)) then
    open_output_window()
  end
  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(output_win, { 1, 0 })
end

-- run SQL command asynchronously using :DB
function M.run_query()
  local query = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  if query == "" then
    vim.notify("Empty query", vim.log.levels.WARN)
    return
  end

  local db = vim.g.dbs and vim.g.dbs["DB_DEFAULT"] or nil
  if not db then
    vim.notify("No default DB connection (DB_DEFAULT missing in .env)", vim.log.levels.ERROR)
    return
  end

  local buf, win, cur_win = open_output_window()
  write_to_output({ "Executing query asynchronously..." })

  vim.fn.jobstart({ "bash", "-c", "echo \"" .. query:gsub('"', '\\"') .. "\" | DBUI_URL=" .. db .. " nvim --headless +'DB'" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then write_to_output(data) end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        table.insert(data, 1, "[ERROR]")
        write_to_output(data)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Query complete", vim.log.levels.INFO)
      else
        vim.notify("Query exited with code " .. code, vim.log.levels.ERROR)
      end
    end,
  })

  vim.api.nvim_set_current_win(cur_win)
end

-- setup keymaps
function M.setup_keymaps()
  local map = vim.keymap.set
  map("n", "<leader>sq", M.run_query, { desc = "Run SQL query asynchronously" })
end

-- setup autocommands
function M.setup_autocmds()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
      M.setup_keymaps()
    end,
    desc = "SQL: map async query runner",
  })
end

function M.setup()
  M.setup_autocmds()
end

return M
