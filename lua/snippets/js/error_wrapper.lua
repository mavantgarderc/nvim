local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ewrap",
		fmt(
			[[
function errorWrap(fn) {{
  return async (req, res, next) => {{
    try {{
      await fn(req, res);
    }} catch (err) {{
      next(err);
    }}
  }};
}}
]],
			{}
		)
	),
}
