local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"ssg",
		fmt(
			[[
const {} = sessionStorage.getItem('{}');
]],
			{ i(1, "value"), i(2, "key") }
		)
	),
}
