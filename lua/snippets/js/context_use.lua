local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"usectx",
		fmt(
			[[
const {value} = React.useContext({Context});
  ]],
			{
				value = ls.insert_node(1, "ctx"),
				Context = ls.insert_node(2, "AppContext"),
			}
		)
	),
}
