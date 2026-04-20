local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"refprops",
		fmt(
			[[
var props = typeof({Type}).GetProperties();
foreach (var p in props)
{{
    Console.WriteLine($"{p.Name}: {p.PropertyType}");
}}
  ]],
			{
				Type = ls.insert_node(1, "MyClass"),
			}
		)
	),
}
