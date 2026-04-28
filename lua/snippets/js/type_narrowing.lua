local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nar",
		fmt(
			[[
if (typeof {} === '{}') {{
  {}
}}
]],
			{ i(1, "val"), i(2, "string"), i(3) }
		)
	),
}
