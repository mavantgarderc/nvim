local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"refattrs",
		fmt(
			[[
var attrs = typeof({Type}).GetCustomAttributes(typeof({Attr}), inherit: true);
foreach (var a in attrs)
{{
    Console.WriteLine(a);
}}
  ]],
			{
				Type = ls.insert_node(1, "MyClass"),
				Attr = ls.insert_node(2, "MyAttr"),
			}
		)
	),
}
