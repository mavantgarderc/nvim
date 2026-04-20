local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"iob",
		fmt(
			[[
const observer = new IntersectionObserver((entries) => {{
  entries.forEach(entry => {{
    if (entry.isIntersecting) {{
      {}
    }}
  }});
}}, {{
  threshold: {}
}});

observer.observe({});
]],
			{
				i(1, "// on intersect"),
				i(2, "0.5"),
				i(3, "element"),
			}
		)
	),
}
