local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"cget",
		fmt(
			[[
const {} = document.cookie
  .split('; ')
  .find(row => row.startsWith('{}='))
  ?.split('=')[1];
]],
			{ i(1, "cookieValue"), i(2, "name") }
		)
	),
}
