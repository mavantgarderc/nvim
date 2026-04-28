local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"ucb",
		fmt(
			[[
const {} = React.useCallback(({}) => {{
  {}
}}, [{}]);
]],
			{ i(1, "fn"), i(2), i(3), i(4) }
		)
	),
}
