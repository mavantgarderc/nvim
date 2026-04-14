local M = {}

M.monorepo_markers = {
	"pnpm-workspace.yaml",
	"package.json",
	"lerna.json",
	"nx.json",
	"workspace.json",
	"turbo.json",
	"rush.json",
	"yarn.lock",
	"pnpm-lock.yaml",
	"pyproject.toml",
	"poetry.lock",
	"requirements.txt",
	"setup.cfg",
	"setup.py",
	"Pipfile",
	"Pipfile.lock",
	"environment.yml",
	"dvc.yaml",
	"dvc.lock",
	"MLproject",
	"mlflow.yaml",
	"params.yaml",
	"metadata.yaml",
	"CMakeLists.txt",
	"Makefile",
	"compile_commands.json",
	"Cargo.toml",
	"Cargo.lock",
	"go.work",
	"go.mod",
	"WORKSPACE",
	"WORKSPACE.bazel",
	"MODULE.bazel",
	"BUILD",
	"BUILD.bazel",
	"build.sbt",
	"pom.xml",
	"gradlew",
	"settings.gradle",
	"terraform.tf",
	"terragrunt.hcl",
	"helmfile.yaml",
	"Chart.yaml",
	"docker-compose.yaml",
	".git",
}

M.workspace_types = {
	node = { "package.json", "pnpm-workspace.yaml", "yarn.lock", "pnpm-lock.yaml" },
	python = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
	rust = { "Cargo.toml", "Cargo.lock" },
	go = { "go.mod", "go.work" },
	latex = { ".latexmkrc", "latexmkrc", ".texlabroot", "Tectonic.toml" },
	docker = { "Dockerfile", "docker-compose.yaml", "docker-compose.yml" },
}

function M.detect_workspace_type(root)
	root = root or vim.fn.getcwd()
	local detected = {}
	for wtype, markers in pairs(M.workspace_types) do
		for _, marker in ipairs(markers) do
			if vim.fn.filereadable(root .. "/" .. marker) == 1 then
				detected[wtype] = true
				break
			end
		end
	end
	return detected
end

local function upward_search(startpath, markers)
	local dir = vim.fs.dirname(startpath)
	while dir and dir ~= "/" do
		for _, marker in ipairs(markers) do
			local match = vim.fs.find(marker, { upward = false, path = dir })
			if #match > 0 then
				return dir
			end
		end
		dir = vim.fs.dirname(dir)
	end
	return nil
end

function M.find_monorepo_root(startpath)
	startpath = startpath or vim.api.nvim_buf_get_name(0)
	return upward_search(startpath, M.monorepo_markers)
end

local function package_from_root(root)
	return root:match("/packages/([^/]+)$")
		or root:match("/apps/([^/]+)$")
		or root:match("/libs/([^/]+)$")
		or root:match("/modules/([^/]+)$")
		or root:match("/projects/([^/]+)$")
		or root:match("/services/([^/]+)$")
end

function M.find_package_name(path, root)
	path = path or vim.api.nvim_buf_get_name(0)
	root = root or M.find_monorepo_root(path)
	if not path or path == "" or not root then
		return nil
	end

	local pkg = package_from_root(root)
	if pkg then
		return pkg
	end

	if path:find(root, 1, true) ~= 1 or #path <= #root then
		return nil
	end

	local rel = path:sub(#root + 2)
	return rel:match("^packages/([^/]+)/")
		or rel:match("^apps/([^/]+)/")
		or rel:match("^libs/([^/]+)/")
		or rel:match("^modules/([^/]+)/")
		or rel:match("^projects/([^/]+)/")
		or rel:match("^services/([^/]+)/")
		or rel:match("^([^/]+)/")
end

function M.attach_monorepo_root(config, fname)
	local repo = M.find_monorepo_root(fname)
	if repo then
		config.root_dir = repo
		vim.notify("[LSP] monorepo root → " .. repo, vim.log.levels.INFO)
	end
end

return M
