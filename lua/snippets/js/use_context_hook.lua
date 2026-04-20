local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"uctx",
		fmt(
			[[
const {} = React.useContext({}Context);
]],
			{ i(1, "ctx"), i(2, "App") }
		)
	),
}
