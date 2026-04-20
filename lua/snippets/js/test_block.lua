local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"tst",
		fmt(
			[[
test('{}', () => {{
  {}
}});
]],
			{ i(1, "should do something"), i(2) }
		)
	),
}
