local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nlink",
		fmt(
			[[
<Link href="{}">{}</Link>
]],
			{ i(1, "/path"), i(2, "Go") }
		)
	),
}
