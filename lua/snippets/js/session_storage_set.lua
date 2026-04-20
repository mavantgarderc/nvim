local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"sss",
		fmt(
			[[
sessionStorage.setItem('{}', {});
]],
			{ i(1, "key"), i(2, "value") }
		)
	),
}
