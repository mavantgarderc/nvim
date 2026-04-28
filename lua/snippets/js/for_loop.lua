local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras.fmt").rep

return {
	s(
		"fori",
		fmt(
			[[
for (let {} = 0; {} < {}; {}++) {{
  {}
}}
]],
			{ i(1, "i"), rep(1), i(2, "n"), rep(1), i(3) }
		)
	),
}
