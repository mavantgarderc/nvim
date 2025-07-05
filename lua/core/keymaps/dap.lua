local dap = require('dap')
local dapui = require('dapui')
local fn = vim.fn
local map = vim.keymap.set

map("n", "<F5>", dap.continue)
map("n", "<F10>", dap.step_over)
map("n", "<F11>", dap.step_into)
map("n", "<F12>", dap.step_out)

map("n", "<leader>b", dap.toggle_breakpoint)
map("n", "<leader>B", function()
    dap.set_breakpoint(fn.input("Breakpoint condition: "))
end)
map("n", "<leader>lp", function()
    dap.set_breakpoint(nil, nil, fn.input("Log point message: "))
end)

map("n", "<Leader>dr", dap.repl.open)
map("n", "<Leader>du", dapui.toggle)
