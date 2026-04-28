local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"emid",
		fmt(
			[[
app.use((req, res, next) => {{
  {}
  next();
}});
]],
			{ i(1, "// middleware") }
		)
	),
}
