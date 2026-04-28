local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"int",
		fmt(
			[[
interface {} {{
  {}: {};
}}
]],
			{ i(1, "MyInterface"), i(2, "field"), i(3, "string") }
		)
	),
}
