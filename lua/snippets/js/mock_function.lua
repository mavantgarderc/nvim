local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"mock",
		fmt(
			[[
const {} = vi.fn();
]],
			{ i(1, "fn") }
		)
	),
}
