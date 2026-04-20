local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ldsafe",
		fmt(
			[[
import {{ config }} from 'dotenv-safe';
config({{ allowEmptyValues: false }});
]],
			{}
		)
	),
}
