local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"aaf",
		fmt(
			[[
const {} = async ({}) => {{
  {}
}};
]],
			{ i(1, "fn"), i(2), i(3) }
		)
	),
}
