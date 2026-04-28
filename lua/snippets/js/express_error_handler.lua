local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"eerr",
		fmt(
			[[
app.use((err, req, res, next) => {{
  console.error(err);
  res.status(500).json({{ error: err.message }});
}});
]],
			{}
		)
	),
}
