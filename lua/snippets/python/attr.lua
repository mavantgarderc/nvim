local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "at",
		name = "Attribute Line",
		desc = "Inserts a single attribute line for the Attributes section.",
	}, {
		t("    "),
		i(1, "attr"),
		t(": "),
		i(2, "Description of attr."),
	}),
}
