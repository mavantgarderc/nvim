local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"urf",
		fmt(
			[[
const {} = React.useRef({});
]],
			{ i(1, "ref"), i(2, "null") }
		)
	),
}
