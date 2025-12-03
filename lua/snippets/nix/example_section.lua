local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "exsec",
		name = "Nix Example Section",
		desc = "Example attribute in options or meta, as used in Nixpkgs for illustrative usage.",
	}, {
		t('example = "'),
		i(1, "Example value or code snippet."),
		t('";'),
	}),
}
