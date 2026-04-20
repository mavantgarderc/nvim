local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"apikey",
		fmt(
			[[
function apiKeyGuard(key) {{
  return (req, res, next) => {{
    if (req.headers['x-api-key'] !== key) {{
      return res.status(401).json({{ error: 'Invalid API key' }});
    }}
    next();
  }};
}}
]],
			{}
		)
	),
}
