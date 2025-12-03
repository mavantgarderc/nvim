local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "par",
		name = "SQL Parameter Doc Line",
		desc = "Single line for documenting a parameter in procedures/functions.",
	}, {
		t(" *   @"),
		i(1, "param_name"),
		t(" "),
		i(2, "datatype"),
		t(" - "),
		i(3, "Description of parameter."),
	}),
}
