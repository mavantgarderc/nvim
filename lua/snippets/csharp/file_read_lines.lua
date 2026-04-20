local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"readlines",
		fmt(
			[[
var lines = File.ReadLines("{path}");
foreach (var line in lines)
{{
    {body}
}}
  ]],
			{
				path = ls.insert_node(1, "file.txt"),
				body = ls.insert_node(2, "// process line"),
			}
		)
	),
}
