local M = {}

-- Detect monorepo root patterns
M.monorepo_markers = {
	"lerna.json",
	"nx.json",
	"pnpm-workspace.yaml",
	"rush.json",
	".git",
}

function M.find_monorepo_root(startpath)
	local path = startpath or vim.fn.getcwd()
	for _, marker in ipairs(M.monorepo_markers) do
		local found = vim.fn.findfile(marker, path .. ";")
		if found ~= "" then
			return vim.fn.fnamemodify(found, ":h")
		end
	end
	return nil
end

-- Setup LSP with monorepo root
function M.setup_lsp_with_monorepo()
	local monorepo_root = M.find_monorepo_root()
	if monorepo_root then
		vim.notify("Detected monorepo at: " .. monorepo_root, vim.log.levels.INFO)
		-- Configure LSP to use monorepo root
		return monorepo_root
	end
	return nil
end

return M
