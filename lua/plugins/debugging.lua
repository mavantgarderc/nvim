return{
    -- to find adapters, you need to check the repository
    -- then inject them
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
        vim.keymap.set("n", "<leader>dc", dap.continue, {})

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.even_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.even_exited.dapui_config = function()
            dapui.close()
        end
    end

}