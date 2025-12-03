return {
	"folke/flash.nvim",
	lazy = true,
	keys = { "f" },
	opts = {
		labels = "abcdefghijklmnopqrstuvwxyz",

		search = {
			multi_window = true,
			forward = true,
			wrap = true,
			mode = "exact",
			incremental = false,
			exclude = {
				"notify",
				"cmp_menu",
				"noice",
				"flash_prompt",
			},
			trigger = "",
			max_length = false,
		},

		jump = {
			jumplist = true,
			pos = "start",
			history = false,
			register = false,
			nohlsearch = false,
			autojump = false,
			inclusive = nil,
			offset = nil,
		},

		label = {
			uppercase = true,
			exclude = "",
			current = true,
			after = true,
			before = false,
			style = "overlay",
			reuse = "lowercase",
			distance = true,
			min_pattern_length = 0,
			rainbow = {
				enabled = false,
				shade = 1,
			},
		},

		highlight = {
			backdrop = true,
			matches = true,
			priority = 5000,
			groups = {
				match = "FlashMatch",
				current = "FlashCurrent",
				backdrop = "FlashBackdrop",
				label = "FlashLabel",
			},
		},

		modes = {
			search = {
				enabled = false,
				highlight = { backdrop = false },
				jump = { history = true, register = true, nohlsearch = true },
				search = {
					mode = "search",
					max_length = 0,
					forward = true,
					wrap = true,
					multi_window = true,
				},
			},

			char = {
				enabled = true,
				config = function(mode_opts)
					local mode_ok, mode_result = pcall(vim.fn.mode, true)
					local operator_ok, operator_result = pcall(function()
						return vim.v.operator
					end)

					if mode_ok and operator_ok then
						mode_opts.autohide = mode_opts.autohide == nil and (mode_result:find("no") and operator_result == "y")
					end
					mode_opts.jump_labels = mode_opts.jump_labels == nil and false
				end,
				autohide = false,
				jump_labels = false,
				multi_line = true,
				label = { exclude = "hjkliardc" },
				keys = { "T" },
				char_actions = function(motion)
					return {
						[";"] = "next",
						[","] = "prev",
						[motion:lower()] = "next",
						[motion:upper()] = "prev",
					}
				end,
				search = { wrap = false },
				highlight = { backdrop = true },
				jump = { register = false },
			},

			treesitter = {
				labels = "abcdefghijklmnopqrstuvwxyz",
				jump = { pos = "range" },
				search = { incremental = false },
				label = { before = true, after = true, style = "inline" },
				highlight = {
					backdrop = false,
					matches = false,
				},
			},

			treesitter_search = {
				jump = { pos = "range" },
				search = { multi_window = true, wrap = true, incremental = false },
				remote_op = { restore = true },
				label = { before = true, after = true, style = "inline" },
			},

			remote = {
				remote_op = { restore = true, motion = true },
			},
		},

		prompt = {
			enabled = true,
			prefix = { { "⚡", "FlashPromptIcon" } },
			win_config = {
				relative = "editor",
				width = 1,
				height = 1,
				row = -1,
				col = 0,
				zindex = 1000,
			},
		},

		remote_op = {
			restore = false,
			motion = false,
		},
	},

	config = function(_, plugin_opts)
		local flash_ok, flash = pcall(require, "flash")
		if not flash_ok then
			vim.notify("Flash.nvim failed to load: " .. tostring(flash), vim.log.levels.ERROR)
			return
		end

		local setup_ok, setup_err = pcall(flash.setup, plugin_opts)
		if not setup_ok then
			vim.notify("Flash.nvim setup failed: " .. tostring(setup_err), vim.log.levels.ERROR)
			return
		end

		local function setup_flash_highlights()
			local function get_hl_color(group, attr)
				local hl_ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
				if not hl_ok or not hl then
					return nil
				end
				return hl[attr] and string.format("#%06x", hl[attr]) or nil
			end

			local function safe_set_hl(name, hl_opts)
				local hl_set_ok, err = pcall(vim.api.nvim_set_hl, 0, name, hl_opts)
				if not hl_set_ok then
					vim.notify("Failed to set highlight " .. name .. ": " .. tostring(err), vim.log.levels.WARN)
				end
			end

			local search_bg = get_hl_color("Search", "bg") or get_hl_color("IncSearch", "bg") or "#ff9900"
			local search_fg = get_hl_color("Search", "fg") or get_hl_color("IncSearch", "fg") or "#000000"
			local error_bg = get_hl_color("ErrorMsg", "bg") or get_hl_color("DiagnosticError", "fg") or "#ff0000"
			local error_fg = get_hl_color("ErrorMsg", "fg") or "#ffffff"
			local comment_fg = get_hl_color("Comment", "fg") or "#545c7e"
			local visual_bg = get_hl_color("Visual", "bg") or get_hl_color("CursorLine", "bg") or "#ff007c"
			local visual_fg = get_hl_color("Visual", "fg") or "#ffffff"
			local keyword_fg = get_hl_color("Keyword", "fg") or get_hl_color("Function", "fg") or "#ff9900"

			safe_set_hl("FlashMatch", { bg = search_bg, fg = search_fg, bold = true })
			safe_set_hl("FlashCurrent", { bg = error_bg, fg = error_fg, bold = true })
			safe_set_hl("FlashBackdrop", { fg = comment_fg })
			safe_set_hl("FlashLabel", { bg = visual_bg, fg = visual_fg, bold = true })
			safe_set_hl("FlashPromptIcon", { fg = keyword_fg })
		end

		setup_flash_highlights()

		local highlight_group = vim.api.nvim_create_augroup("FlashHighlights", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = highlight_group,
			pattern = "*",
			callback = setup_flash_highlights,
		})

		local function setup_category_highlights()
			local categories = {
				{ "FlashClass", "Type" },
				{ "FlashMethod", "Function" },
				{ "FlashAccess", "StorageClass" },
				{ "FlashModifier", "Keyword" },
				{ "FlashVariable", "Identifier" },
				{ "FlashConditionals", "Conditional" },
				{ "FlashIterators", "Repeat" },
				{ "FlashOperators", "Operator" },
				{ "FlashConstants", "Constant" },
				{ "FlashStorage", "StorageClass" },
				{ "FlashComments", "Todo" },
			}

			for _, category in ipairs(categories) do
				local link_ok, err = pcall(vim.api.nvim_set_hl, 0, category[1], { link = category[2] })
				if not link_ok then
					vim.notify(
						"Failed to link " .. category[1] .. " to " .. category[2] .. ": " .. tostring(err),
						vim.log.levels.WARN
					)
				end
			end
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = highlight_group,
			pattern = "*",
			callback = setup_category_highlights,
		})

		setup_category_highlights()

		local cursor_group = vim.api.nvim_create_augroup("FlashCursor", { clear = true })

		vim.api.nvim_create_autocmd("User", {
			group = cursor_group,
			pattern = "FlashPromptPre",
			callback = function()
				local cursor_ok, err = pcall(function()
					vim.opt.guicursor = "n:block-FlashCursor"
				end)
				if not cursor_ok then
					vim.notify("Flash cursor setup failed: " .. tostring(err), vim.log.levels.WARN)
				end
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			group = cursor_group,
			pattern = "FlashPromptPost",
			callback = function()
				local cursor_ok, err = pcall(function()
					vim.opt.guicursor = "n:block"
				end)
				if not cursor_ok then
					vim.notify("Flash cursor restore failed: " .. tostring(err), vim.log.levels.WARN)
				end
			end,
		})

		local keymaps_ok, keymaps_err = pcall(require, "core.keymaps.flash")
		if not keymaps_ok then
			vim.notify("Flash keymaps failed to load: " .. tostring(keymaps_err), vim.log.levels.WARN)
			local map = vim.keymap.set
			map({ "n", "x", "o" }, "ff", function()
				local jump_ok, err = pcall(function()
					require("flash").jump()
				end)
				if not jump_ok then
					vim.notify("Flash jump failed: " .. tostring(err), vim.log.levels.ERROR)
				end
			end, { desc = "Flash jump" })
		end
	end,
}
