return {
	-- Core DAP
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		lazy = true,
		cmd = { "DapContinue", "DapToggleBreakpoint" },
		keys = { "<leader>d" },
		nfig = function()
			local dap = require("dap")
			local dapui = require("dapui")

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

			---@diagnostic disable-next-line: different-requires
			require("core.keymaps.dap")

			-- C#/CoreCLR
			dap.adapters.coreclr = {
				type = "executable",
				command = "/usr/bin/netcoredbg",
				args = { "--interpreter=vscode" },
			}

			local function find_dll_path()
				local patterns = {
					"**/bin/Debug/net*/!(*Test*).dll",
					"**/bin/Debug/net*/*.dll",
					"bin/Debug/net*/*.dll",
					"**/Debug/*.dll",
				}

				for _, pattern in ipairs(patterns) do
					local dll_files = vim.fn.glob(pattern, false, true)
					if dll_files and #dll_files > 0 then
						if #dll_files > 1 then
							local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							for _, dll in ipairs(dll_files) do
								if string.match(dll, cwd_name) then
									return dll
								end
							end
						end
						return dll_files[1]
					end
				end
				return nil
			end

			local function build_dotnet_project()
				print("Building .NET project...")
				local result = vim.fn.system("dotnet build 2>&1")
				local exit_code = vim.v.shell_error
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
					type = "coreclr",
					name = "Launch - .NET Core",
					request = "launch",
					console = "integratedTerminal",
					program = function()
						if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
							if not build_dotnet_project() then
								if vim.fn.confirm("Build failed. Continue anyway?", "&yes\n&no", 2) ~= 1 then
									return nil
								end
							end
						end
						local dll_path = find_dll_path()
						if dll_path then
							print("Found DLL: " .. dll_path)
							local choice = vim.fn.confirm("Use found DLL?\n" .. dll_path, "&yes\n&choose different", 1)
							if choice == 1 then
								return dll_path
							end
						end
						local manual_path = vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
						if manual_path == "" then
							print("No DLL specified, canceling debug session")
							return nil
						end
						return manual_path
					end,
				},
				{
					type = "coreclr",
					name = "Launch - .NET Core (No Build)",
					request = "launch",
					console = "integratedTerminal",
					program = function()
						local dll_path = find_dll_path()
						if dll_path then
							return dll_path
						end
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			}
		end,
	},

	-- Python DAP (separate spec for proper lazy-loading and CI safety)
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		lazy = true,
		enabled = not vim.env.CI, -- disables in CI builds
		config = function()
			local fn = vim.fn
			local notify = vim.notify
			local log = vim.log

			local debugpy_path = fn.expand("~/.virtualenvs/debugpy/bin/python")
			if fn.executable(debugpy_path) == 1 then
				require("dap-python").setup(debugpy_path)
			else
				notify(
					"debugpy not installed. Create with:\n"
						.. "python3 -m venv ~/.virtualenvs/debugpy\n"
						.. "~/.virtualenvs/debugpy/bin/python -m pip install debugpy",
					log.levels.WARN
				)
			end
		end,
	},
}
