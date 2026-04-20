local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"rtr",
		fmt(
			[[
render(<{} {} />);
]],
			{ i(1, "Component"), i(2) }
		)
	),
}
