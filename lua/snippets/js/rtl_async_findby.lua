local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"fby",
		fmt(
			[[
const {} = await screen.findBy{}('{}');
]],
			{
				i(1, "el"),
				i(2, "Text"),
				i(3, "Loaded"),
			}
		)
	),
}
