local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"asmload",
		fmt(
			[[
var asm = Assembly.LoadFrom("{path}");
var types = asm.GetTypes();
foreach (var t in types)
{{
    Console.WriteLine(t.FullName);
}}
  ]],
			{
				path = ls.insert_node(1, "my.dll"),
			}
		)
	),
}
