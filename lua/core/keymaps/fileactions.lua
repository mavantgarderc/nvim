local map = vim.keymap.set
local cmd = vim.cmd
local bo = vim.bo
local notify = vim.notify
local log = vim.log

map("n", "<leader>X", ":!chmod +x %<CR>", { silent = true, desc = "Execution permission to the current file" })

map("n", "<leader>oo", function()
    cmd("wall")
    local filetype = bo.filetype
    if filetype == "lua" then
        cmd("source %")
        notify(" 󱓎 ", log.levels.INFO)
    else
        notify(" 󱓎 ", log.levels.INFO)
    end
end, { desc = "Save all; source if Lua" })

map("n", "<leader>o<leader>o", ":wa<CR>:qa", { desc = "Save all, then quit; confirmation needed" })
