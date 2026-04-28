local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"listadd",
		fmt(
			[[
var list = new List<{Type}>()
{{
    {values}
}};
  ]],
			{
				Type = ls.insert_node(1, "int"),
				values = ls.insert_node(2, "1, 2, 3"),
			}
		)
	),
}
