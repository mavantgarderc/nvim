local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"lenv",
		fmt(
			[[
import 'dotenv/config';

const config = {{
  PORT: process.env.PORT || 3000,
  NODE_ENV: process.env.NODE_ENV || 'development',
  {}
}};

export default config;
]],
			{ i(1) }
		)
	),
}
