local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras.rep").rep
local i = ls.insert_node

return {
	s(
		"ass",
		fmt(
			[[
function {}({}: any): asserts {} is {} {{
  if (!({})) {{
    throw new Error('{} failed');
  }}
}}
]],
			{
				i(1, "assertThing"),
				i(2, "value"),
				rep(2),
				i(3, "Type"),
				i(4, "/* condition */"),
				i(5, "assertion"),
			}
		)
	),
}
