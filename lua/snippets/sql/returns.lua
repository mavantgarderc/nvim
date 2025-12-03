local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ret",
		name = "SQL Returns Doc Section",
		desc = "Section for documenting return values.",
	}, {
		t({ " *", " * Returns: " }),
		i(1, "datatype"),
		t(" - "),
		i(2, "Description of return value."),
	}),
}
