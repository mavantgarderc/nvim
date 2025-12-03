local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "opt",
		name = "NixOS Option Description",
		desc = "Attribute for describing a NixOS module option, as per Nixpkgs manual.",
	}, {
		t('description = "'),
		i(1, "Brief description of the option."),
		t('";'),
	}),
}
