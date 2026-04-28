local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"use",
		fmt(
			[[
const [{}, {}] = React.useState({});
]],
			{ i(1, "value"), i(2, "setValue"), i(3, "null") }
		)
	),
}
