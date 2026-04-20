local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"guard",
		fmt(
			[[
function authGuard(req, res, next) {{
  if (!req.headers.authorization) {{
    return res.status(401).json({{ error: 'Unauthorized' }});
  }}
  {}
  next();
}}
]],
			{ i(1, "// validate token") }
		)
	),
}
