return {
	{
		"tpope/vim-dadbod",
		lazy = true,
		cmd = "DB",
		ft = "*sql",
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },

		init = function()
			local function map(mode, lhs, rhs, opts)
				local options = { noremap = true, silent = true }
				if opts then
					options = vim.tbl_extend("force", options, opts)
				end
				vim.keymap.set(mode, lhs, rhs, options)
			end

			local function with_db(callback)
				local db = vim.b.db or vim.g.db
				if db then
					callback(db)
					return
				end

				local conns = vim.g.dbs or {}
				if vim.tbl_isempty(conns) then
					vim.notify("No database connections configured", vim.log.levels.WARN)
					return
				end

				vim.ui.select(vim.tbl_keys(conns), { prompt = "Select database:" }, function(choice)
					if choice and conns[choice] then
						callback(conns[choice])
					end
				end)
			end

			local ok, keymaps = pcall(require, "core.keymaps.dadbod")
			if ok and type(keymaps.setup) == "function" then
				pcall(keymaps.setup, map, with_db)
			else
				vim.notify("core.keymaps.dadbod not found or failed to load", vim.log.levels.WARN)
			end

			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_winwidth = 40
			vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"
			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_execute_on_save = 0
		end,

		config = function()
			-- Load .env if exists (cwd first, fallback to config/)
			local dotenv_path = vim.fn.getcwd() .. "/.env"
			local config_env = vim.fn.stdpath("config") .. "/.env"

			if vim.fn.filereadable(dotenv_path) == 1 then
				vim.cmd("silent! Dotenv " .. dotenv_path)
			elseif vim.fn.filereadable(config_env) == 1 then
				vim.cmd("silent! Dotenv " .. config_env)
			else
				vim.notify("No .env file found in cwd or config dir", vim.log.levels.WARN)
			end

			-- Load structured DB profiles: ~/.config/nvim/db_profiles.json
			local function load_profiles()
				local path = vim.fn.stdpath("config") .. "/db_profiles.json"
				if vim.fn.filereadable(path) == 0 then
					return {}
				end
				local ok, decoded = pcall(function()
					return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
				end)
				if not ok then
					vim.notify("Failed to parse db_profiles.json", vim.log.levels.ERROR)
					return {}
				end
				return decoded
			end

			local DB_PROFILES = load_profiles()

			-- Merge profiles into vim.g.dbs (dadbod expects flat strings)
			local function merge_profiles_into_dbs()
				vim.g.dbs = vim.g.dbs or {}

				for name, entry in pairs(DB_PROFILES) do
					if type(entry) == "table" and entry.url then
						vim.g.dbs[name] = entry.url
					end
				end
			end

			merge_profiles_into_dbs()

			-- Command: select a profile (UI)
			vim.api.nvim_create_user_command("DBProfileSelect", function()
				local names = vim.tbl_keys(DB_PROFILES)
				if vim.tbl_isempty(names) then
					vim.notify("No db_profiles.json profiles defined", vim.log.levels.WARN)
					return
				end

				vim.ui.select(names, { prompt = "Select DB Profile:" }, function(choice)
					if not choice then
						return
					end
					local profile = DB_PROFILES[choice]
					if profile and profile.url then
						vim.g.db = profile.url
						vim.notify("Active DB profile: " .. choice, vim.log.levels.INFO)
					end
				end)
			end, {})

			-- Command: switch directly (:DBSwitch profile_name)
			vim.api.nvim_create_user_command("DBSwitch", function(opts)
				local name = opts.args
				local profile = DB_PROFILES[name]
				if profile and profile.url then
					vim.g.db = profile.url
					vim.notify("Switched DB to profile: " .. name, vim.log.levels.INFO)
				else
					vim.notify("Profile '" .. name .. "' not found", vim.log.levels.ERROR)
				end
			end, {
				nargs = 1,
				complete = function()
					return vim.tbl_keys(DB_PROFILES)
				end,
			})

			-- Query executor (kept from your original version)
			_G.DadbodExecute = function(query, db_key)
				if not vim.g.dbs or not vim.g.dbs[db_key] or vim.g.dbs[db_key] == "" then
					local available = vim.g.dbs and table.concat(vim.tbl_keys(vim.g.dbs), ", ") or "none"
					vim.notify(
						string.format(
							"Database '%s' not found or empty URL.\nAvailable: %s\nCheck .env or db_profiles.json",
							db_key,
							available
						),
						vim.log.levels.ERROR
					)
					return
				end

				local db_url = vim.g.dbs[db_key]

				vim.cmd("botright 15split")
				local result_buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_win_set_buf(0, result_buf)

				vim.bo[result_buf].filetype = "dbout"
				vim.bo[result_buf].buftype = "nofile"
				vim.bo[result_buf].bufhidden = "wipe"

				vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, vim.split(query, "\n"))
				vim.fn.execute("%DB " .. vim.fn.fnameescape(db_url))

				vim.notify("Query executed on " .. db_key, vim.log.levels.INFO)
			end
		end,
	},

	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = "vim-dadbod",
		ft = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },

		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
				callback = function()
					local ok, cmp = pcall(require, "cmp")
					if ok then
						local sources = vim.tbl_deep_extend("force", cmp.get_config().sources or {}, {
							{ name = "vim-dadbod-completion" },
						})
						cmp.setup.buffer({ sources = sources })
					else
						vim.bo.omnifunc = "vim_dadbod_completion#omni"
					end
				end,
			})
		end,
	},
}
