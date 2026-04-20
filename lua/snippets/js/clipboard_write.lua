local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"clipw",
		fmt(
			[[
await navigator.clipboard.writeText({});
]],
			{ i(1, "'text'") }
		)
	),
}
