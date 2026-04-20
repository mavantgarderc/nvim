local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ur",
		fmt(
			[[
const [{state}, {dispatch}] = React.useReducer({reducer}, {init});
  ]],
			{
				state = ls.insert_node(1, "state"),
				dispatch = ls.insert_node(2, "dispatch"),
				reducer = ls.insert_node(3, "reducer"),
				init = ls.insert_node(4, "{}"),
			}
		)
	),
}
