local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ex",
		name = "SQL Example Doc Section",
		desc = "Section for providing an example usage.",
	}, {
		t({ " *", " * Example:", " *   " }),
		i(1, "SQL statement or call;"),
	}),
}
