local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ctx",
		fmt(
			[[
const {Name}Context = React.createContext({defaultValue});
  ]],
			{
				Name = ls.insert_node(1, "App"),
				defaultValue = ls.insert_node(2, "null"),
			}
		)
	),
}
