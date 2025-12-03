local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "fod",
		name = "Nix Flake Output Description",
		desc = "Description attribute for flake outputs, often used in flake.nix for packages or apps.",
	}, {
		t('description = "'),
		i(1, "Description of the flake output."),
		t('";'),
	}),
}
