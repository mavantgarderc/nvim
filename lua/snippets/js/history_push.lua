local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"hpush",
		fmt(
			[[
history.pushState({}, '', '{}');
]],
			{ i(1, "/path") }
		)
	),
}
