local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"lreq",
		fmt(
			[[
function requireEnv(key) {{
  const value = process.env[key];
  if (!value) throw new Error(`Missing env ${{key}}`);
  return value;
}}
]],
			{}
		)
	),
}
