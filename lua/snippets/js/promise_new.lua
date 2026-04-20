local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"pro",
		fmt(
			[[
const {} = new Promise((resolve, reject) => {{
  {}
}});
]],
			{ i(1, "p"), i(2, "// async logic") }
		)
	),
}
