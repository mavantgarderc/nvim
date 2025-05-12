-- ============================================================================
-- DAP Configuration — plugins/dap.lua
-- ============================================================================
-- Debug Adapter Protocol: Provides consistent debug interface for multiple languages
-- ============================================================================

local dap = pcall(require, "dap")

-- Node.js debug adapter (vscode-node-debug2)
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { "/path/to/vscode-node-debug2/out/src/nodeDebug.js" },
}

dap.configurations.javascript = {
  {
    name = "Launch Node.js",
    type = "node2",
    request = "launch",
    program = "${workspaceFolder}/app.js",
  },
}

-- Python debug adapter (debugpy)
dap.adapters.python = {
  type = "executable",
  command = "/usr/bin/python3",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    name = "Launch Python",
    type = "python",
    request = "launch",
    program = "${workspaceFolder}/main.py",
  },
}

-- -- C/C++ debug adapter (lldb-vscode)
-- dap.adapters.cpp = {
--   type = "executable",
--   command = "lldb-vscode",
--   name = "lldb",
-- }

-- dap.configurations.cpp = {
--   {
--     name = "Launch C++ Program",
--     type = "cpp",
--     request = "launch",
--     program = "${file}",
--     cwd = "${workspaceFolder}",
--     stopOnEntry = false,
--   },
-- }

-- Keymaps for debugging
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open Debug REPL" })

-- ============================================================================
-- DAP initialized
-- ============================================================================
