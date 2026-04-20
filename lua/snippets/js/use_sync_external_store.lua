local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"uses",
		fmt(
			[[
const {value} = React.useSyncExternalStore(
  {subscribe},
  {getSnapshot},
  {getServerSnapshot}
);
  ]],
			{
				value = ls.insert_node(1, "value"),
				subscribe = ls.insert_node(2, "subscribe"),
				getSnapshot = ls.insert_node(3, "getSnapshot"),
				getServerSnapshot = ls.insert_node(4, "getServerSnapshot"),
			}
		)
	),
}
