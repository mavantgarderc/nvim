local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"tenv",
		fmt(
			[[
function env(key, fallback) {{
  return process.env[key] ?? fallback;
}}
]],
			{}
		)
	),
}
