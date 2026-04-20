local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"easync",
		fmt(
			[[
const {} = async (req, res, next) => {{
  try {{
    {}
    next();
  }} catch (err) {{
    next(err);
  }}
}};
]],
			{
				i(1, "middleware"),
				i(2, "// logic"),
			}
		)
	),
}
