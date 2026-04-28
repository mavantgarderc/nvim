local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"lconf",
		fmt(
			[[
import {{ z }} from 'zod';

const Schema = z.object({{
  PORT: z.string().transform(Number),
  {}
}});

const config = Schema.parse(process.env);
export default config;
]],
			{ i(1) }
		)
	),
}
