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
            local fn = vim.fn
            local notify = vim.notify
            local log = vim.log
            local v = vim.v

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

            -- Load DAP keymaps
            require('core.keymaps.dap')

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

            -- ShiSherp 🇮🇳
            dap.adapters.coreclr = {
                type = 'executable',
                command = "/usr/bin/netcoredbg",
                args = { '--interpreter=vscode' }
            }

            local function find_dll_path()
                local patterns = {
                    '**/bin/Debug/net*/!(*Test*).dll', -- exclude test DLLs
                    '**/bin/Debug/net*/*.dll',         -- any .NET DLL
                    'bin/Debug/net*/*.dll',            -- relative path
                    '**/Debug/*.dll'                   -- alternative debug path
                }

                for _, pattern in ipairs(patterns) do
                    local dll_files = fn.glob(pattern, false, true)
                    if dll_files and #dll_files > 0 then
                        -- multiple DLLs found? pick the one which matching project name
                        if #dll_files > 1 then
                            local cwd_name = fn.fnamemodify(fn.getcwd(), ':t')
                            for _, dll in ipairs(dll_files) do
                                if string.match(dll, cwd_name) then
                                    return dll
                                end
                            end
                        end
                        return dll_files[1] -- Return first match
                    end
                end

                return nil
            end

            -- project build helper function
            local function build_dotnet_project()
                print("Building .NET project...")
                local result = fn.system('dotnet build 2>&1')
                local exit_code = v.shell_error

                if exit_code == 0 then
                    print("Build successful")
                    return true
                else
                    print("Build failed:")
                    print(result)
                    return false
                end
            end

            dap.configurations.cs = {
                {
                    type = 'coreclr',
                    name = 'Launch - .NET Core',
                    request = 'launch',
                    console = "integratedTerminal",
                    program = function()
                        if fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                            if not build_dotnet_project() then
                                if fn.confirm('Build failed. Continue anyway?', '&yes\n&no', 2) ~= 1 then
                                    return nil
                                end
                            end
                        end
                        local dll_path = find_dll_path()
                        if dll_path then
                            print("Found DLL: " .. dll_path)
                            local choice = fn.confirm(
                                'Use found DLL?\n' .. dll_path,
                                '&yes\n&choose different',
                                1
                            )
                            if choice == 1 then
                                return dll_path
                            end
                        end
                        local manual_path = fn.input('Path to dll: ', fn.getcwd() .. '/bin/Debug/', 'file')
                        if manual_path == '' then
                            print("No DLL specified, canceling debug session")
                            return nil
                        end
                        return manual_path
                    end,
                },
                {
                    type = 'coreclr',
                    name = 'Launch - .NET Core (No Build)',
                    request = 'launch',
                    console = "integratedTerminal",
                    program = function()
                        local dll_path = find_dll_path()
                        if dll_path then
                            return dll_path
                        end
                        return fn.input('Path to dll: ', fn.getcwd() .. '/bin/Debug/', 'file')
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
