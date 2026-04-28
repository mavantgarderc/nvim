local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rlazy",
		fmt(
			[[
const {Name} = React.lazy(() => import("{path}"));
  ]],
			{
				Name = ls.insert_node(1, "LazyComponent"),
				path = ls.insert_node(2, "./Component"),
			}
		)
	),
}
