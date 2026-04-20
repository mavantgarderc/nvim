local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"attruse",
		fmt(
			[[
[{Attr}({args})]
public class {Class}
{{
}}
  ]],
			{
				Attr = ls.insert_node(1, "MyAttr"),
				args = ls.insert_node(2, ""),
				Class = ls.insert_node(3, "Example"),
			}
		)
	),
}
