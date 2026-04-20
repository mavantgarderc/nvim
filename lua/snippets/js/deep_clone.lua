local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"clone",
		fmt(
			[[
function deepClone(obj) {{
  return JSON.parse(JSON.stringify(obj));
}}
]],
			{}
		)
	),
}
