local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"then",
		fmt(
			[[
{}.then(({}) => {{
  {}
}}).catch((err) => {{
  console.error(err);
}});
]],
			{ i(1, "promise"), i(2, "result"), i(3) }
		)
	),
}
