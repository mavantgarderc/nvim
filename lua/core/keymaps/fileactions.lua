local bo = vim.bo
local fn = vim.fn
local log = vim.log
local api = vim.api
local map = vim.keymap.set
local cmd = vim.cmd
local notify = vim.notify

-- normalized pasting
map("n", "<leader>p", "\"_dp")

-- interactive replace word under the cursor
map("n", "<leader>x", function()
    local word = fn.expand("<cword>")
    if word == "" then print("No word under cursor") return end
    api.nvim_feedkeys( ":%s/" .. fn.escape(word, "/\\") .. "//gc" .. string.rep(api.nvim_replace_termcodes("<Left>", true, false, true), 3), "n", false)
end, { desc = "Replace word under cursor interactively" })

-- execution permission
map("n", "<leader>X", ":!chmod +x %<CR>", { silent = true })

-- write & source current file
map("n", "<leader>oo", function()
    cmd("write")
    if bo.filetype == "lua" then
        cmd("source %")
        notify(" 󱓎 ", log.levels.INFO)
    else
        notify(" 󱓎 ", log.levels.INFO)
    end
end, { desc = "Save; & source if Lua" })

-- Quit; confirmation needed
map("n", "<leader>o<leader>o", ":wa<CR>:qa")
