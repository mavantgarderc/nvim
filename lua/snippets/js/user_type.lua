local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"uty",
		fmt(
			[[
await userEvent.type({}, '{}');
]],
			{ i(1, "input"), i(2, "text") }
		)
	),
}
