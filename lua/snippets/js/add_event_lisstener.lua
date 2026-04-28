local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"ael",
		fmt(
			[[
{}.addEventListener('{}', (event) => {{
  {}
}});
]],
			{ i(1, "element"), i(2, "click"), i(3) }
		)
	),
}
