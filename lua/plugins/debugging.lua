return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')
            local map = vim.keymap.set
            local fn = vim.fn
            local g = vim.g
            local notify = vim.notify
            local log = vim.log

            dapui.setup()
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

            map('n', '<F5>', dap.continue)
            map('n', '<F10>', dap.step_over)
            map('n', '<F11>', dap.step_into)
            map('n', '<F12>', dap.step_out)

            map('n', '<Leader>b', dap.toggle_breakpoint)
            map('n', '<Leader>B', function()
                dap.set_breakpoint(fn.input('Breakpoint condition: '))
            end)
            map('n', '<Leader>lp', function()
                dap.set_breakpoint(nil, nil, fn.input('Log point message: '))
            end)
            map('n', '<Leader>dr', dap.repl.open)
            map('n', '<Leader>du', dapui.toggle)


            -- Python
            local debugpy_path = fn.expand('~/.virtualenvs/debugpy/bin/python')
            if fn.executable(debugpy_path) == 1 then
                require('dap-python').setup(debugpy_path)
            else
                notify(
                    "debugpy not installed. Create with:\n" ..
                    "python3 -m venv ~/.virtualenvs/debugpy\n" ..
                    "~/.virtualenvs/debugpy/bin/python -m pip install debugpy",
                    log.levels.WARN
                )
            end

            -- C#
            dap.adapters.coreclr = {
                type = 'executable',
                command = "/usr/bin/netcoredbg",
                args = {'--interpreter=vscode'}
            }
            dap.configurations.cs = {
                {
                    type = 'coreclr',
                    name = 'Launch - .NET Core',
                    request = 'launch',
                    console = "iintegratedTerminal",
                    program = function()
                        if fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                            g.dotnet_build_project()
                        end
                        return g.dotnet_get_dll_path()
                    end,
                },

            }

            -- JS/TS
            -- dap.adapters["pwa-node"] = {
            --     type = "server",
            --     host = "localhost",
            --     port = "${port}",
            --     executable = {
            --         command = "node",
            --         args = {os.getenv("HOME") .. "/.vscode-js-debug/src/dapDebugServer.js", "${port}"},
            --     }
            -- }
            -- for _, lang in ipairs({ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }) do
            --     dap.configurations[lang] = {
            --         {
            --             type = "pwa-node",
            --             request = "launch",
            --             name = "Launch Node",
            --             program = "${file}",
            --             cwd = "${workspaceFolder}",
            --         },
            --     }
            -- end
        end
    }
}
