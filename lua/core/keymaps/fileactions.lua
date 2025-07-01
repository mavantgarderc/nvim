local map = vim.keymap.set
local cmd = vim.cmd
local bo = vim.bo
local notify = vim.notify
local log = vim.log

-- normalize pasting
map("x", "<leader>p", '"_dp')

-- replace the cursor under word in buffer, interactively
map("n", "<leader>s", ":%s/<C-r><C-w>//gc<Left><Left><Left>")

-- execution permission
map("n", "<leader>x", ":!chmod +x %<CR>", { silent = true })
map("n", "<leader>X", ":!chmod -x %<CR>", { silent = true })

-- write & source current file
map("n", "<leader>oo", function()
    cmd("write")
    if bo.filetype == "lua" then
        cmd("source %")
        notify("  ", log.levels.INFO)
    else
        notify("  ", log.levels.INFO)
    end
end, { desc = "Save; & source if Lua" })

-- Quit
map("n", "<leader>o<leader>o", ":wa<CR>:qa")
