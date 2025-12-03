local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "args",
		name = "Args Section",
		desc = "Inserts the Args section header with an example parameter.",
	}, {
		t({ "", "Args:", "    " }),
		i(1, "param1"),
		t(": "),
		i(2, "Description of param1."),
	}),
}
