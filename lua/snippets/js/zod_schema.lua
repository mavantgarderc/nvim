local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"zod",
		fmt(
			[[
import {{ z }} from 'zod';

const {}Schema = z.object({{
  {}
}});

export default {}Schema;
]],
			{
				i(1, "User"),
				i(2, "name: z.string(),"),
				i(3, "User"),
			}
		)
	),
}
