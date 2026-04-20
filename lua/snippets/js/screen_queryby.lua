local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"qby",
		fmt("screen.queryBy{}('{}')", {
			i(1, "Text"),
			i(2, "Hello"),
		})
	),
}
