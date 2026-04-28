local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"genf",
		fmt(
			[[
function {}<{}>({}: {}): {} {{
  {}
}}
]],
			{
				i(1, "func"),
				i(2, "T"),
				i(3, "value"),
				i(4, "T"),
				i(5, "T"),
				i(6),
			}
		)
	),
}
