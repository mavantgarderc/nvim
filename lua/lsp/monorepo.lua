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

function M.attach_monorepo_root(config, fname)
	local repo = M.find_monorepo_root(fname)
	if repo then
		config.root_dir = repo
		vim.notify("[LSP] monorepo root → " .. repo, vim.log.levels.INFO)
	end
end

return M
