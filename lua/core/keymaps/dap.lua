local keymap = vim.keymap.set
local dap = require("dap")
local dapui = require("dapui")

-- Basic debugging
keymap("n", "<F5>", dap.continue, { desc = "Continue debugging" })
keymap("n", "<F10>", dap.step_over, { desc = "Step over" })
keymap("n", "<F11>", dap.step_into, { desc = "Step into" })
keymap("n", "<F12>", dap.step_out, { desc = "Step out" })

-- Breakpoints
keymap("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
keymap(
    "n",
    "<leader>B",
    function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
    { desc = "Set conditional breakpoint" }
)
keymap(
    "n",
    "<leader>lp",
    function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
    { desc = "Set log point" }
)

-- DAP UI and utilities
keymap("n", "<leader>dr", dap.repl.open, { desc = "Open DAP REPL" })
keymap("n", "<leader>dl", dap.run_last, { desc = "Run last debug session" })
keymap("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

-- Python specific debugging
keymap("n", "<leader>dn", function() require("dap-python").test_method() end, { desc = "Debug Python test method" })
keymap("n", "<leader>df", function() require("dap-python").test_class() end, { desc = "Debug Python test class" })
keymap("v", "<leader>ds", function() require("dap-python").debug_selection() end, { desc = "Debug Python selection" })
