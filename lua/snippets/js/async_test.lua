local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"tsta",
		fmt(
			[[
test('{}', async () => {{
  {}
}});
]],
			{ i(1, "async test"), i(2) }
		)
	),
}
