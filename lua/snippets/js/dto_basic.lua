local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"dto",
		fmt(
			[[
class {}DTO {{
  constructor({}) {{
    {}
  }}
}}
]],
			{
				i(1, "User"),
				i(2, "data"),
				i(3, "this.name = data.name;"),
			}
		)
	),
}
