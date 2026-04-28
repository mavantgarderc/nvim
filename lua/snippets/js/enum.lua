local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"enu",
		fmt(
			[[
enum {} {{
  {} = '{}',
}}
]],
			{ i(1, "Status"), i(2, "OK"), i(3, "OK") }
		)
	),
}
