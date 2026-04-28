local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"taf",
		fmt(
			[[
const {} = ({}: {}): {} => {{
  {}
}};
]],
			{
				i(1, "fn"),
				i(2, "arg"),
				i(3, "string"),
				i(4, "number"),
				i(5),
			}
		)
	),
}
