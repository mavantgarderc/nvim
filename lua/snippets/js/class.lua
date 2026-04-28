local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"class",
		fmt(
			[[
class {} {{
  constructor({}) {{
    {}
  }}
}}
]],
			{ i(1, "MyClass"), i(2), i(3) }
		)
	),
}
