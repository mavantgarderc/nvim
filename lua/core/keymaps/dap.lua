local dap = require("dap")
local dapui = require("dapui")
local map = vim.keymap.set
local fn = vim.fn

-- Basic debugging
map("n", "<F05>", dap.continue,  { desc = "Continue debugging" })
map("n", "<F10>", dap.step_over, { desc = "Step over"          })
map("n", "<F11>", dap.step_into, { desc = "Step into"          })
map("n", "<F12>", dap.step_out,  { desc = "Step out"           })

-- Breakpoints
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

map( "n", "<leader>dB", function()
    dap.set_breakpoint(fn.input("Breakpoint condition: "))
end, { desc = "Set conditional breakpoint" })

map( "n", "<leader>dl", function()
    dap.set_breakpoint(nil, nil, fn.input("Log point message: "))
end, { desc = "Set log point" })

-- DAP UI and utilities
map("n", "<leader>dr", dap.repl.open, { desc = "Open DAP REPL" })
map("n", "<leader>dl", dap.run_last, { desc = "Run last debug session" })
map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

-- Python specific debugging
map("n", "<leader>dn", function()
    require("dap-python").test_method()
end, { desc = "Debug Python test method" })

map("n", "<leader>df", function()
    require("dap-python").test_class()
end, { desc = "Debug Python test class" })

map("v", "<leader>ds", function()
    require("dap-python").debug_selection()
end, { desc = "Debug Python selection" })
