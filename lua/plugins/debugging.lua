return {
    -- Debug Adapter Protocol (DAP) core
    "mfussenegger/nvim-dap",
    dependencies = {
        -- Debug UI
        "rcarriga/nvim-dap-ui",
        -- Required by dap-ui
        "nvim-neotest/nvim-nio",
    },

    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local map = vim.keymap.set

        dapui.setup()

        map("n", "<leader>dt", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
        map("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })

        -- Auto-open/close dapui with DAP events
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end,
}
