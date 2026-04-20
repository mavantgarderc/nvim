local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"desc",
		fmt(
			[[
describe('{}', () => {{
  {}
}});
]],
			{ i(1, "suite"), i(2) }
		)
	),
}
