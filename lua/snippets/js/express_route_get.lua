local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"eget",
		fmt(
			[[
app.get('{}', async (req, res) => {{
  try {{
    {}
    res.json({{ ok: true }});
  }} catch (err) {{
    res.status(500).json({{ error: err.message }});
  }}
}});
]],
			{ i(1, "/"), i(2) }
		)
	),
}
