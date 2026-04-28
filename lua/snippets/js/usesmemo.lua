local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"ume",
		fmt(
			[[
const {} = React.useMemo(() => {{
  return {};
}}, [{}]);
]],
			{ i(1, "memoized"), i(2, "value"), i(3) }
		)
	),
}
