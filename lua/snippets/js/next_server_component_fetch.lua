local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nsf",
		fmt(
			[[
const data = await fetch('{}', {{
  method: 'GET',
  cache: 'no-store'
}}).then(res => res.json());
]],
			{ i(1, "/api/endpoint") }
		)
	),
}
