local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"lrun",
		fmt(
			[[
export function loadConfig(path) {{
  const raw = require(path);
  return typeof raw === 'function' ? raw() : raw;
}}
]],
			{}
		)
	),
}
