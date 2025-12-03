local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "par",
		name = "Parameter Line",
		desc = "Inserts a single parameter line for the Args section.",
	}, {
		t("    "),
		i(1, "param"),
		t(": "),
		i(2, "Description of param."),
	}),
}
