local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"dtots",
		fmt(
			[[
interface {}DTO {{
  {}
}}

class {} implements {}DTO {{
  constructor(public {} ) {{}}
}}
]],
			{
				i(1, "User"),
				i(2, "name: string;"),
				i(3, "UserDTO"),
				i(4, "UserDTO"),
				i(5, "name: string"),
			}
		)
	),
}
