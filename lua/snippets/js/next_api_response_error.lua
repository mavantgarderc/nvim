local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nerr",
		fmt(
			[[
return new Response(JSON.stringify({{
  error: '{}'
}}), {{
  status: {}
}});
]],
			{ i(1, "Something went wrong"), i(2, "400") }
		)
	),
}
