local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"cset",
		fmt(
			[[
document.cookie = "{}={}; path=/; max-age={}";
]],
			{ i(1, "name"), i(2, "value"), i(3, "3600") }
		)
	),
}
