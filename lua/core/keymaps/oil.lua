local oil = require("oil")
local Path = require("plenary.path")
local map = vim.keymap.set

local M = {}

M.setup = function()
  map("n", "<leader>fo", ":Oil<CR>", { desc = "Open parent directory in Oil" })

  map("n", "<leader>fO", function()
    oil.open_float()
  end, { desc = "Open Oil in floating window" })

  map("n", "<leader>foo", function()
    oil.open(vim.fn.getcwd())
  end, { desc = "Open Oil in cwd" })

  local oil_sidebar_win = nil
  map("n", "<leader>e", function()
    if oil_sidebar_win and vim.api.nvim_win_is_valid(oil_sidebar_win) then
      vim.api.nvim_win_close(oil_sidebar_win, true)
      oil_sidebar_win = nil
    else
      vim.cmd("vsplit | wincmd l | vertical resize 30")
      oil.open()
      oil_sidebar_win = vim.api.nvim_get_current_win()
    end
  end, { desc = "Toggle Oil sidebar" })

  map("n", "<leader>nf", function()
    if vim.bo.filetype ~= "oil" then
      return vim.notify("Not in oil buffer", vim.log.levels.WARN)
    end
    vim.ui.input({ prompt = "New file name: " }, function(input)
      if input then
        local dir = oil.get_current_dir()
        local path = Path:new(dir):joinpath(input):absolute()
        vim.cmd("edit " .. vim.fn.fnameescape(path))
      end
    end)
  end, { desc = "Create new file in Oil" })

  map("n", "<leader>nd", function()
    if vim.bo.filetype ~= "oil" then
      return vim.notify("Not in oil buffer", vim.log.levels.WARN)
    end
    vim.ui.input({ prompt = "New directory name: " }, function(input)
      if input then
        local dir = oil.get_current_dir()
        local path = Path:new(dir):joinpath(input):absolute()
        vim.fn.mkdir(path, "p")
        oil.open(dir)
      end
    end)
  end, { desc = "Create new directory in Oil" })

  map("n", "<leader>ok", ":OilCheatsheet<CR>", { desc = "Open Oil Cheatsheet" })
end

return M
