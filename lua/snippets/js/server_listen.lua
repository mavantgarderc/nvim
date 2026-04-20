local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"listen",
		fmt(
			[[
const PORT = {};
app.listen(PORT, () => {{
  console.log(`Server running on port ${{PORT}}`);
}});
]],
			{ i(1, "3000") }
		)
	),
}
