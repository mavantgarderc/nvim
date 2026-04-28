local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mlog",
		fmt(
			[[
function requestLogger(req, res, next) {{
  console.log(`${{req.method}} ${{req.url}}`);
  next();
}}
]],
			{}
		)
	),
}
