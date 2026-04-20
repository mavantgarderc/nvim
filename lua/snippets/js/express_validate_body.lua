local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"eval",
		fmt(
			[[
function validateBody(schema) {{
  return (req, res, next) => {{
    const parsed = schema.safeParse(req.body);
    if (!parsed.success) {{
      return res.status(400).json({{ errors: parsed.error.errors }});
    }}
    req.data = parsed.data;
    next();
  }};
}}
]],
			{}
		)
	),
}
