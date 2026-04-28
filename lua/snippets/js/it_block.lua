local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"it",
		fmt(
			[[
it('{}', () => {{
  {}
}});
]],
			{ i(1, "works"), i(2) }
		)
	),
}
