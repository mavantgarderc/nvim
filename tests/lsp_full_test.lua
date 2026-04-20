--[[
  LSP integration smoke tests.
  Run:
  XDG_CACHE_HOME=/tmp/codex-nvim-cache \
  XDG_STATE_HOME=/tmp/codex-nvim-state \
  NVIM_LOG_FILE=/tmp/codex-nvim.log \
  nvim --headless -u NONE -i NONE \
    --cmd "set rtp+=." \
    --cmd "set rtp+=~/.local/share/nvim/lazy/telescope.nvim" \
    --cmd "set rtp+=~/.local/share/nvim/lazy/plenary.nvim" \
    --cmd "set rtp+=~/.local/share/nvim/lazy/nvim-lspconfig" \
    --cmd "set rtp+=~/.local/share/nvim/lazy/cmp-nvim-lsp" \
    --cmd "set rtp+=~/.local/share/nvim/lazy/mason.nvim" \
    --cmd "set rtp+=~/.local/share/nvim/lazy/mason-lspconfig.nvim" \
    -l tests/lsp_full_test.lua
]]

local passed = 0
local failed = 0
local total = 0
local section = 0

local original_notify = vim.notify
vim.notify = function()
	return nil
end

local function test(name, fn)
	total = total + 1
	local ok, err = pcall(fn)
	if ok then
		passed = passed + 1
		print("  [PASS] " .. name)
	else
		failed = failed + 1
		print("  [FAIL] " .. name .. ": " .. tostring(err))
	end
end

local function describe(name, fn)
	section = section + 1
	print(string.format("\n[%d] %s", section, name))
	fn()
end

local function require_ok(module_name)
	local ok, mod = pcall(require, module_name)
	assert(ok, string.format("failed to require %s: %s", module_name, tostring(mod)))
	return mod
end

local function assert_command(name)
	local commands = vim.api.nvim_get_commands({ builtin = false })
	assert(commands[name], "expected user command " .. name)
end

local function find_keymap(mode, lhs, bufnr)
	local current = vim.api.nvim_get_current_buf()
	if bufnr then
		vim.api.nvim_set_current_buf(bufnr)
	end

	local ok, keymap = pcall(vim.fn.maparg, lhs, mode, false, true)
	if bufnr and current ~= bufnr then
		vim.api.nvim_set_current_buf(current)
	end

	if not ok or type(keymap) ~= "table" or vim.tbl_isempty(keymap) then
		return nil
	end

	return keymap
end

local function assert_keymap(mode, lhs, expected, bufnr)
	local keymap = find_keymap(mode, lhs, bufnr)
	assert(keymap, string.format("expected %s mapping for %s", mode, lhs))
	if expected then
		assert(
			keymap.rhs and keymap.rhs:find(expected, 1, true),
			string.format("expected %s rhs to contain %s, got %s", lhs, expected, keymap.rhs or "<nil>")
		)
	end
	return keymap
end

local function assert_callback_keymap(mode, lhs, bufnr)
	local keymap = find_keymap(mode, lhs, bufnr)
	assert(keymap, string.format("expected %s mapping for %s", mode, lhs))
	assert(keymap.callback ~= nil, string.format("expected %s to use a Lua callback", lhs))
	return keymap
end

local function assert_command_or_callback_keymap(mode, lhs, expected, bufnr)
	local keymap = find_keymap(mode, lhs, bufnr)
	assert(keymap, string.format("expected %s mapping for %s", mode, lhs))
	local has_expected_rhs = expected and keymap.rhs and keymap.rhs:find(expected, 1, true)
	assert(
		has_expected_rhs or keymap.callback ~= nil,
		string.format("expected %s to use %s or a Lua callback", lhs, expected or "a command")
	)
	return keymap
end

local function fresh_buffer(filetype)
	local bufnr = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_set_current_buf(bufnr)
	if filetype then
		vim.bo[bufnr].filetype = filetype
	end
	return bufnr
end

local function trigger_lsp_attach(bufnr)
	vim.api.nvim_exec_autocmds("LspAttach", {
		buffer = bufnr,
		modeline = false,
		data = { client_id = -1 },
	})
end

local function load_with_setup(module_name, opts)
	local mod = require_ok(module_name)
	assert(type(mod.setup) == "function", module_name .. " should export setup()")
	mod.setup(opts)
	mod.setup(opts)
	return mod
end

describe("module loading", function()
	for _, module_name in ipairs({
		"lsp.monorepo",
		"lsp.shared",
		"lsp.dynamic",
		"lsp.toggle",
		"lsp.health",
		"lsp.info",
		"lsp.symbol_index",
		"lsp.analytics",
		"lsp.filetypes",
		"lsp.references",
		"lsp.rename",
		"lsp.codelens",
		"lsp.code_actions",
		"lsp.hover",
		"lsp.inlay_hint",
		"lsp.lightbulb",
		"lsp.virtual_text",
		"lsp.definition_peek",
		"lsp.implementation",
		"lsp.type_definition",
		"lsp.call_hierarchy",
		"lsp.workspace_symbol",
		"lsp.capability_inspector",
		"lsp.semantic_tokens",
		"lsp.keymaps",
		"core.keymaps.lsp",
	}) do
		test(module_name .. " loads", function()
			local mod = require_ok(module_name)
			assert(mod == nil or type(mod) == "table" or mod == true)
		end)
	end

	test("legacy keymap shim points at lsp.keymaps", function()
		assert(require_ok("core.keymaps.lsp").setup == require_ok("lsp.keymaps").setup)
	end)
end)

describe("command registration", function()
	local expectations = {
		{ module = "lsp.info", commands = { "LspInfo" } },
		{ module = "lsp.analytics", commands = { "LspAnalytics" } },
		{ module = "lsp.references", commands = { "LspRefFind", "LspRefSummary" } },
		{
			module = "lsp.rename",
			commands = { "Rename", "RenameQuick", "RenameUndo", "RenameHistory", "RenameSummary" },
		},
		{ module = "lsp.codelens", commands = { "LensToggle", "LensRun", "LensRefresh", "LensStatus" } },
		{ module = "lsp.diagnostics", commands = { "DiagSummary", "DiagFocus", "DiagPicker" } },
		{ module = "lsp.symbol_index", commands = { "SymbolIndex", "SymbolIndexClear" } },
		{ module = "lsp.progress", commands = { "LspProgress", "LspProgressClear" } },
		{ module = "lsp.code_actions", commands = { "CodeAction", "CodeActionTelescope", "CodeActionHistory" } },
		{ module = "lsp.hover", commands = { "LspHover", "LspHoverPin", "LspHoverUnpin" } },
		{ module = "lsp.inlay_hint", commands = { "InlayToggle", "InlayRefresh", "InlayStatus" }, opts = { auto_enable = false } },
		{
			module = "lsp.semantic_tokens",
			commands = { "LspSemanticTokensToggle", "LspSemanticTokensGlobal", "LspSemanticTokensStatus" },
		},
		{ module = "lsp.virtual_text", commands = { "LspVirtualTextToggle" } },
		{ module = "lsp.workspace_symbol", commands = { "LspWorkspaceSymbol" } },
		{ module = "lsp.implementation", commands = { "LspImplementation" } },
		{ module = "lsp.type_definition", commands = { "LspTypeDefinition", "LspTypePeek" } },
		{ module = "lsp.definition_peek", commands = { "LspPeekDefinition", "LspPeekClose" } },
		{ module = "lsp.call_hierarchy", commands = { "LspCallHierarchy", "LspIncomingCalls", "LspOutgoingCalls" } },
		{ module = "lsp.capability_inspector", commands = { "LspCapabilities" } },
		{ module = "lsp.toggle", commands = { "LspToggleCurrent", "LspToggleGlobal" } },
	}

	for _, item in ipairs(expectations) do
		test(item.module .. " setup is idempotent", function()
			load_with_setup(item.module, item.opts)
			for _, command_name in ipairs(item.commands) do
				assert_command(command_name)
			end
		end)
	end
end)

describe("module behavior", function()
	test("monorepo finds package names for repo and package roots", function()
		local mod = require_ok("lsp.monorepo")
		assert(mod.find_package_name("/repo/packages/api/src/main.lua", "/repo") == "api")
		assert(mod.find_package_name("/repo/apps/web/src/main.ts", "/repo") == "web")
		assert(mod.find_package_name("/repo/packages/api/src/main.lua", "/repo/packages/api") == "api")
		assert(mod.find_package_name("/repo/tools/build.lua", "/repo") == "tools")
		assert(mod.find_package_name("/repo/init.lua", "/repo") == nil)
	end)

	test("info renders attached client details in a markdown float", function()
		local mod = require_ok("lsp.info")
		local original_get_clients = vim.lsp.get_clients
		local buf, win
		local ok, err = pcall(function()
			fresh_buffer("lua")
			vim.lsp.get_clients = function(opts)
				assert(opts.bufnr == 0)
				return {
					{
						name = "lua_ls",
						id = 7,
						config = { root_dir = "/tmp/project", filetypes = { "lua" } },
						server_capabilities = {
							hoverProvider = true,
							renameProvider = true,
						},
					},
				}
			end

			buf, win = mod.show_server_info()
			assert(type(buf) == "number" and vim.api.nvim_buf_is_valid(buf))
			assert(type(win) == "number" and vim.api.nvim_win_is_valid(win))
			assert(vim.bo[buf].filetype == "markdown")

			local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
			assert(content:find("## lua_ls", 1, true))
			assert(content:find("- hoverProvider", 1, true))
			assert(content:find("- renameProvider", 1, true))
		end)
		vim.lsp.get_clients = original_get_clients
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		assert(ok, err)
	end)

	test("analytics reports registry and active counts", function()
		local mod = require_ok("lsp.analytics")
		local dynamic = require_ok("lsp.dynamic")
		local original_get_clients = vim.lsp.get_clients
		local original_registry = dynamic.registry
		local original_active = dynamic.active
		local previous_notify = vim.notify
		local message
		local ok, err = pcall(function()
			fresh_buffer("lua")
			dynamic.registry = {
				lua_ls = { filetypes = { "lua" } },
				pyright = { filetypes = { "python" } },
			}
			dynamic.active = {
				lua_ls = { last_used = os.time() },
			}
			vim.lsp.get_clients = function()
				return {
					{
						name = "lua_ls",
						config = { root_dir = "/tmp/project" },
					},
				}
			end
			vim.notify = function(msg)
				message = msg
				return nil
			end

			mod.show_report()
			assert(type(message) == "string")
			assert(message:find("Current filetype: lua", 1, true))
			assert(message:find("Attached clients: 1", 1, true))
			assert(message:find("Dynamic registry size: 2", 1, true))
			assert(message:find("Dynamic active count: 1", 1, true))
		end)
		vim.lsp.get_clients = original_get_clients
		dynamic.registry = original_registry
		dynamic.active = original_active
		vim.notify = previous_notify
		assert(ok, err)
	end)

	test("symbol_index resolves workspace roots through monorepo helper", function()
		local mod = require_ok("lsp.symbol_index")
		local monorepo = require_ok("lsp.monorepo")
		local original_find_root = monorepo.find_monorepo_root
		local ok, err = pcall(function()
			local bufnr = fresh_buffer("lua")
			local fname = "/tmp/workspace/pkg/main.lua"
			vim.api.nvim_buf_set_name(bufnr, fname)
			monorepo.find_monorepo_root = function(path)
				assert(path == fname)
				return "/tmp/workspace"
			end
			assert(mod._find_workspace_root() == "/tmp/workspace")
		end)
		monorepo.find_monorepo_root = original_find_root
		assert(ok, err)
	end)

	test("code_actions filters by kind prefix", function()
		local mod = require_ok("lsp.code_actions")
		local filtered = mod.filter_by_kind({
			{ action = { kind = "quickfix.fix" } },
			{ action = { kind = "refactor.extract" } },
			{ action = { kind = "source.fixAll" } },
		}, "quickfix")
		assert(#filtered == 1)
		assert(filtered[1].action.kind == "quickfix.fix")
	end)

	test("definition_peek exposes open_location helper", function()
		local mod = require_ok("lsp.definition_peek")
		assert(type(mod.open_location) == "function")
	end)

	test("virtual_text toggles diagnostic config reliably", function()
		local mod = require_ok("lsp.virtual_text")
		mod.setup({ enabled = true, prefix = ">> ", max_length = 32 })
		assert(mod.is_enabled() == true)
		local config = vim.diagnostic.config()
		assert(type(config.virtual_text) == "table")
		assert(config.virtual_text.prefix == ">> ")
		assert(config.severity_sort == true)
		mod.toggle()
		assert(mod.is_enabled() == false)
		assert(vim.diagnostic.config().virtual_text == false)
		mod.toggle()
		assert(mod.is_enabled() == true)
	end)

	test("inlay_hint setup applies config without forcing autocmds on", function()
		local mod = require_ok("lsp.inlay_hint")
		mod.setup({ auto_enable = false, filetypes = { "lua" } })
		assert(mod.config.auto_enable == false)
		assert(vim.deep_equal(mod.config.filetypes, { "lua" }))
		assert(mod.is_enabled() == false)
	end)

	test("semantic_tokens status remains well-typed across toggles", function()
		local mod = require_ok("lsp.semantic_tokens")
		mod.setup()
		local before = mod.status()
		assert(type(before.global) == "boolean")
		assert(type(before.buffer) == "boolean")
		assert(type(before.disabled_ft) == "boolean")
		mod.toggle_global()
		local flipped = mod.status()
		assert(flipped.global ~= before.global)
		mod.toggle_global()
		assert(mod.status().global == before.global)
	end)

	test("toggle module exports compatibility helpers", function()
		local mod = require_ok("lsp.toggle")
		assert(type(mod.start_server) == "function")
		assert(type(mod.stop_server) == "function")
		assert(type(mod.toggle_lsp) == "function")
		assert(type(mod.toggle_lsp_globally) == "function")
	end)
end)

describe("keymap wiring", function()
	test("lsp keymaps install shared global command maps", function()
		load_with_setup("lsp.info")
		load_with_setup("lsp.analytics")
		load_with_setup("lsp.hover")
		load_with_setup("lsp.inlay_hint", { auto_enable = false })
		load_with_setup("lsp.codelens")
		load_with_setup("lsp.rename")
		load_with_setup("lsp.references")
		load_with_setup("lsp.diagnostics")
		load_with_setup("lsp.symbol_index")
		load_with_setup("lsp.progress")
		local keymaps = load_with_setup("lsp.keymaps")
		assert(type(keymaps.setup_lsp_keymaps) == "function")

		assert_keymap("n", "<leader>lh", "LspHealth")
		assert_keymap("n", "<leader>lp", "LspProgress")
		assert_keymap("n", "<leader>lI", "LspInfo")
		assert_keymap("n", "<leader>la", "LspAnalytics")
		assert_keymap("n", "<leader>kp", "LspHoverPin")
		assert_keymap("n", "<leader>ku", "LspHoverUnpin")
		assert_keymap("n", "<leader>ci", "InlayToggle")
		assert_keymap("n", "<leader>cl", "LensRun")
		assert_keymap("n", "<leader>cL", "LensToggle")
		assert_keymap("n", "<leader>rn", "Rename")
		assert_keymap("n", "<leader>rN", "RenameQuick")
		assert_keymap("n", "<leader>ru", "RenameUndo")
		assert_keymap("n", "<leader>rh", "RenameHistory")
		assert_keymap("n", "<leader>ri", "RenameSummary")
		assert_command_or_callback_keymap("n", "grr", "LspRefFind")
		assert_keymap("n", "grs", "LspRefSummary")
		assert_keymap("n", "<leader>dS", "DiagSummary")
		assert_callback_keymap("n", "<leader>ds")
		assert_keymap("n", "<leader>dp", "DiagPicker")
		assert_keymap("n", "<leader>sS", "SymbolIndex")
		assert_callback_keymap("n", "<leader>ss")
		assert_keymap("n", "<leader>lT", "LspToggleGlobal")
	end)

	test("lsp keymaps use command-backed mappings on LspAttach", function()
		load_with_setup("lsp.toggle")
		load_with_setup("lsp.code_actions")
		load_with_setup("lsp.hover")
		load_with_setup("lsp.workspace_symbol")
		load_with_setup("lsp.implementation")
		load_with_setup("lsp.type_definition")
		local keymaps = load_with_setup("lsp.keymaps")
		assert(type(keymaps.setup_lsp_keymaps) == "function")

		local bufnr = fresh_buffer("lua")
		vim.keymap.set("n", "<leader>lw", "<Cmd>echo existing-workspace-map<CR>", { buffer = bufnr, silent = true })
		trigger_lsp_attach(bufnr)

		assert_keymap("n", "<leader>K", "LspHover", bufnr)
		assert_keymap("n", "<leader>gi", "LspImplementation", bufnr)
		assert_keymap("n", "<leader>go", "LspTypeDefinition", bufnr)
		assert_keymap("n", "<leader>gp", "LspTypePeek", bufnr)
		assert_keymap("n", "<leader>gr", "LspRefFind", bufnr)
		assert_keymap("n", "<leader>ca", "CodeAction", bufnr)
		assert_keymap("n", "<leader>gra", "CodeActionTelescope", bufnr)
		assert_keymap("n", "<leader>fs", "LspWorkspaceSymbol", bufnr)
		assert_keymap("n", "<leader>lt", "LspTypePeek", bufnr)
		assert_keymap("n", "<leader>lx", "LspToggleCurrent", bufnr)
		assert_keymap("n", "<leader>lw", "existing-workspace-map", bufnr)
		assert_keymap("n", "<leader>lT", "LspToggleGlobal")
	end)
end)

describe("bootstrap", function()
	test("lspconfig bootstrap wires helper commands and keymaps", function()
		local original_mason_lspconfig = package.loaded["mason-lspconfig"]
		local original_lspconfig = package.loaded["lsp.lspconfig"]
		local captured_opts
		local ok, err = pcall(function()
			package.loaded["mason-lspconfig"] = {
				setup = function(opts)
					captured_opts = opts
				end,
			}
			package.loaded["lsp.lspconfig"] = nil
			require_ok("lsp.lspconfig")
			assert(type(captured_opts) == "table")
			assert(type(captured_opts.ensure_installed) == "table")

			for _, command_name in ipairs({
				"LspInfo",
				"LspAnalytics",
				"LspHover",
				"LspProgress",
				"CodeAction",
				"LspRefFind",
				"Rename",
				"LensToggle",
				"DiagSummary",
				"SymbolIndex",
				"LspWorkspaceSymbol",
				"LspImplementation",
				"LspTypeDefinition",
				"LspToggleCurrent",
				"LspToggleGlobal",
			}) do
				assert_command(command_name)
			end

			assert_keymap("n", "<leader>lI", "LspInfo")
			assert_keymap("n", "<leader>la", "LspAnalytics")
			assert_keymap("n", "<leader>lp", "LspProgress")
		end)
		package.loaded["mason-lspconfig"] = original_mason_lspconfig
		package.loaded["lsp.lspconfig"] = original_lspconfig
		assert(ok, err)
	end)
end)

describe("server configs", function()
	for _, name in ipairs({
		"css",
		"docker",
		"go",
		"graphql",
		"html",
		"json",
		"latex",
		"lua_ls",
		"omnisharp",
		"python",
		"rust_analyzer",
		"solidity",
		"sql",
		"ts_ls",
		"yamlls",
		"zig",
	}) do
		test(name .. " server config loads", function()
			local mod = require_ok("lsp.servers." .. name)
			assert(type(mod) == "table")
		end)
	end
end)

print("\n========================================")
print(string.format("Total: %d | Passed: %d | Failed: %d", total, passed, failed))
print("========================================")

vim.notify = original_notify

if failed > 0 then
	os.exit(1)
end
