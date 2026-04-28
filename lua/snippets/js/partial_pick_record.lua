local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"uty",
		fmt(
			[[
type {} = Partial<{}>;
type {} = Pick<{}, '{}'>;
type {} = Record<{}, {}>;
]],
			{
				i(1, "PartialType"),
				i(2, "T"),
				i(3, "Picked"),
				i(4, "T"),
				i(5, "key"),
				i(6, "MapType"),
				i(7, "string"),
				i(8, "number"),
			}
		)
	),
}
