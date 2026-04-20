local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"forof",
		fmt(
			[[
for (const {} of {}) {{
  {}
}}
]],
			{ i(1, "item"), i(2, "arr"), i(3) }
		)
	),
}
