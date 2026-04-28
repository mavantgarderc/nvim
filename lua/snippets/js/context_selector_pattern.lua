local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ctxsel",
		fmt(
			[[
const {Selected} = React.useContextSelector(
  {Context},
  (v) => v.{field}
);
  ]],
			{
				Selected = ls.insert_node(1, "value"),
				Context = ls.insert_node(2, "AppContext"),
				field = ls.insert_node(3, "field"),
			}
		)
	),
}
