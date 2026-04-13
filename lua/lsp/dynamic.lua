local M = {}

local monorepo = require("lsp.monorepo")
local shared = require("lsp.shared")

-- Server registry: filetype → server definitions
M.registry = {
	ts_ls = {
		filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "tsx", "jsx" },
		root_markers = { "package.json", "tsconfig.json", "jsconfig.json", "pnpm-workspace.yaml" },
		timeout = 5 * 60,
	},
	pyright = {
		filetypes = { "python" },
		root_markers = { "pyproject.toml", "requirements.txt", "setup.py", "setup.cfg", "pyrightconfig.json" },
		timeout = 5 * 60,
	},
	rust_analyzer = {
		filetypes = { "rust" },
		root_markers = { "Cargo.toml" },
		timeout = 10 * 60,
	},
	gopls = {
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_markers = { "go.mod", "go.work" },
		timeout = 5 * 60,
	},
	lua_ls = {
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml", ".stylua.toml" },
		timeout = 10 * 60,
	},
	html = {
		filetypes = { "html", "templ" },
		root_markers = { "package.json", ".git" },
		timeout = 5 * 60,
	},
	cssls = {
		filetypes = { "css", "scss", "less" },
		root_markers = { "package.json", ".git" },
		timeout = 5 * 60,
	},
	jsonls = {
		filetypes = { "json", "jsonc" },
		root_markers = { "package.json", ".git" },
		timeout = 5 * 60,
	},
	yamlls = {
		filetypes = { "yaml", "yaml.docker-compose" },
		root_markers = { ".git" },
		timeout = 5 * 60,
	},
	dockerls = {
		filetypes = { "dockerfile" },
		root_markers = { "Dockerfile", "docker-compose.yaml", "docker-compose.yml" },
		timeout = 5 * 60,
	},
	bashls = {
		filetypes = { "sh", "bash", "zsh" },
		root_markers = { ".git" },
		timeout = 5 * 60,
	},
	tailwindcss = {
		filetypes = { "html", "css", "javascript", "typescript", "typescriptreact", "javascriptreact", "vue", "svelte" },
		root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "tailwind.config.mjs" },
		timeout = 5 * 60,
	},
	eslint = {
		filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
		root_markers = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.json",
			".eslintrc.yml",
			"eslint.config.js",
			"eslint.config.mjs",
		},
		timeout = 5 * 60,
	},
	terraformls = {
		filetypes = { "terraform", "terraform-vars", "hcl" },
		root_markers = { "*.tf", "terraform.tf", "terragrunt.hcl" },
		timeout = 5 * 60,
	},
	vimls = {
		filetypes = { "vim" },
		root_markers = { ".git" },
		timeout = 10 * 60,
	},
}

-- Workspace profiles
-- Each profile: list of servers to prioritize when markers are found at root
M.profiles = {
	node = {
		markers = {
			"package.json",
			"tsconfig.json",
			"jsconfig.json",
			"pnpm-workspace.yaml",
			"yarn.lock",
			"pnpm-lock.yaml",
		},
		servers = { "ts_ls", "eslint", "tailwindcss", "html", "cssls", "jsonls" },
	},
	python = {
		markers = {
			"pyproject.toml",
			"requirements.txt",
			"setup.py",
			"Pipfile",
			"environment.yml",
			"pyrightconfig.json",
		},
		servers = { "pyright" },
	},
	rust = {
		markers = { "Cargo.toml", "Cargo.lock" },
		servers = { "rust_analyzer" },
	},
	go = {
		markers = { "go.mod", "go.work" },
		servers = { "gopls" },
	},
	lua = {
		markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml" },
		servers = { "lua_ls" },
	},
	terraform = {
		markers = { "terraform.tf", "terragrunt.hcl" },
		servers = { "terraformls" },
	},
	docker = {
		markers = { "Dockerfile", "docker-compose.yaml", "docker-compose.yml" },
		servers = { "dockerls" },
	},
}

-- always allowed regardless of profile
M.universal_servers = { "jsonls", "yamlls", "bashls", "vimls" }

-- State
M.active = {} -- server_name → { last_used = timestamp }
M.workspace_cache = {} -- root_dir → { profiles = {}, servers = {} }

-- Profile detection
function M.detect_profiles(root)
	if not root then
		return {}, {}
	end

	if M.workspace_cache[root] then
		return M.workspace_cache[root].profiles, M.workspace_cache[root].servers
	end

	local matched_profiles = {}
	local allowed_servers = {}

	-- check each profile
	for profile_name, profile in pairs(M.profiles) do
		for _, marker in ipairs(profile.markers) do
			local found = vim.fs.find(marker, { path = root, upward = false, type = "file" })
			if #found > 0 then
				matched_profiles[profile_name] = true
				for _, srv in ipairs(profile.servers) do
					allowed_servers[srv] = true
				end
				break
			end
		end
	end

	-- universal servers always allowed
	for _, srv in ipairs(M.universal_servers) do
		allowed_servers[srv] = true
	end

	M.workspace_cache[root] = {
		profiles = matched_profiles,
		servers = allowed_servers,
	}

	return matched_profiles, allowed_servers
end

-- On-demand spawning
local function server_has_filetype(server_name, ft)
	local entry = M.registry[server_name]
	if not entry then
		return false
	end
	return vim.tbl_contains(entry.filetypes, ft)
end

local function find_root_for_server(server_name, bufname)
	local entry = M.registry[server_name]
	if not entry then
		return nil
	end

	-- try server-specific root markers first
	local root = vim.fs.root(bufname, entry.root_markers)
	if root then
		return root
	end

	-- fallback to monorepo root
	return monorepo.find_monorepo_root(bufname)
end

function M.try_spawn(server_name, bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if bufname == "" then
		return
	end

	local root = find_root_for_server(server_name, bufname)
	if not root then
		return
	end

	-- check workspace profile allows this server
	local _, allowed = M.detect_profiles(root)
	if not allowed[server_name] then
		return
	end

	-- check if already running for this root
	local clients = vim.lsp.get_clients({ name = server_name })
	for _, client in ipairs(clients) do
		if client.config.root_dir == root then
			-- already running, just touch timestamp
			M.active[server_name] = { last_used = os.time() }
			return
		end
	end

	-- load custom server config if exists
	local opts = {}
	local ok, custom = pcall(require, "lsp.servers." .. server_name)
	if ok and type(custom) == "table" and custom.setup then
		-- server module handles its own setup
		custom.setup(shared.capabilities)
		M.active[server_name] = { last_used = os.time() }
		local profiles_str = vim.tbl_keys(M.detect_profiles(root))
		vim.notify(
			("[LSP] ⚡ %s started (root: %s, profiles: %s)"):format(
				server_name,
				vim.fn.fnamemodify(root, ":~"),
				table.concat(profiles_str, ", ")
			),
			vim.log.levels.INFO
		)
		return
	end

	-- fallback: configure and enable directly
	vim.lsp.config(server_name, {
		capabilities = shared.capabilities,
		root_dir = root,
	})
	vim.lsp.enable(server_name)

	M.active[server_name] = { last_used = os.time() }

	local profiles_str = vim.tbl_keys(M.detect_profiles(root))
	vim.notify(
		("[LSP] ⚡ %s started (root: %s, profiles: %s)"):format(
			server_name,
			vim.fn.fnamemodify(root, ":~"),
			table.concat(profiles_str, ", ")
		),
		vim.log.levels.INFO
	)
end

-- Idle reaper
local reaper_interval = 60 -- check every 60s

function M.reap_idle()
	local now = os.time()
	for server_name, state in pairs(M.active) do
		local entry = M.registry[server_name]
		if entry and (now - state.last_used) > entry.timeout then
			local clients = vim.lsp.get_clients({ name = server_name })
			for _, client in ipairs(clients) do
				-- only kill if no buffers are actively using it
				local attached_bufs = vim.lsp.get_buffers_by_client_id(client.id)
				local any_visible = false
				for _, bufnr in ipairs(attached_bufs) do
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_buf(win) == bufnr then
							any_visible = true
							break
						end
					end
					if any_visible then
						break
					end
				end

				if not any_visible then
					vim.lsp.stop_client(client.id, true)
					vim.notify(
						("[LSP] 💤 %s stopped (idle %ds)"):format(server_name, now - state.last_used),
						vim.log.levels.INFO
					)
					M.active[server_name] = nil
				else
					-- still visible, refresh timestamp
					state.last_used = now
				end
			end
		end
	end
end

-- Build filetype → servers lookup (inverted index)
local ft_to_servers = {}
for server_name, entry in pairs(M.registry) do
	for _, ft in ipairs(entry.filetypes) do
		ft_to_servers[ft] = ft_to_servers[ft] or {}
		table.insert(ft_to_servers[ft], server_name)
	end
end

-- Autocmds
local group = vim.api.nvim_create_augroup("LspDynamic", { clear = true })

-- spawn on filetype
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(ev)
		local ft = ev.match
		local servers = ft_to_servers[ft]
		if not servers then
			return
		end

		-- slight defer to let buffer fully initialize
		vim.defer_fn(function()
			for _, server_name in ipairs(servers) do
				M.try_spawn(server_name, ev.buf)
			end
		end, 50)
	end,
})

-- touch timestamp on BufEnter to keep active servers alive
vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	callback = function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if M.active[client.name] then
				M.active[client.name].last_used = os.time()
			end
		end
	end,
})

-- start idle reaper timer
local timer = vim.uv.new_timer()
timer:start(
	reaper_interval * 1000,
	reaper_interval * 1000,
	vim.schedule_wrap(function()
		M.reap_idle()
	end)
)

-- User commands
vim.api.nvim_create_user_command("LspProfiles", function()
	local bufname = vim.api.nvim_buf_get_name(0)
	local root = monorepo.find_monorepo_root(bufname) or vim.fn.getcwd()
	local profiles, servers = M.detect_profiles(root)

	local lines = { "Workspace: " .. vim.fn.fnamemodify(root, ":~"), "" }
	table.insert(lines, "Detected profiles:")
	if vim.tbl_isempty(profiles) then
		table.insert(lines, "  (none)")
	else
		for p, _ in pairs(profiles) do
			table.insert(lines, "  • " .. p)
		end
	end

	table.insert(lines, "")
	table.insert(lines, "Allowed servers:")
	for s, _ in pairs(servers) do
		local status = M.active[s] and "● running" or "○ idle"
		table.insert(lines, ("  %s  %s"):format(status, s))
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show LSP workspace profiles" })

vim.api.nvim_create_user_command("LspDynamicStatus", function()
	local lines = { "Active LSP servers:", "" }
	if vim.tbl_isempty(M.active) then
		table.insert(lines, "  (none)")
	else
		for name, state in pairs(M.active) do
			local age = os.time() - state.last_used
			local entry = M.registry[name]
			local ttl = entry and (entry.timeout - age) or 0
			table.insert(lines, ("  %s — last used %ds ago, reap in %ds"):format(name, age, math.max(0, ttl)))
		end
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show dynamic LSP status" })

vim.api.nvim_create_user_command("LspProfilesReset", function()
	M.workspace_cache = {}
	vim.notify("[LSP] Workspace profile cache cleared", vim.log.levels.INFO)
end, { desc = "Clear workspace profile cache" })

return M
