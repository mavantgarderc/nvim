local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"spy",
		fmt(
			[[
const {} = vi.spyOn({}, '{}');
]],
			{
				i(1, "spy"),
				i(2, "obj"),
				i(3, "method"),
			}
		)
	),
}
