local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"lconfts",
		fmt(
			[[
interface Config {{
  {}
}}

const config: Config = {{
  {}
}};

export default config;
]],
			{ i(1, "port: number"), i(2, "port: 3000") }
		)
	),
}
