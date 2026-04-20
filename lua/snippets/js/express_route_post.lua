local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"epost",
		fmt(
			[[
app.post('{}', async (req, res) => {{
  try {{
    const data = req.body;
    {}
    res.json({{ received: data }});
  }} catch (err) {{
    res.status(500).json({{ error: err.message }});
  }}
}});
]],
			{ i(1, "/submit"), i(2) }
		)
	),
}
