local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"streamread",
		fmt(
			[[
using var reader = new StreamReader("{path}");
var text = reader.ReadToEnd();
  ]],
			{
				path = ls.insert_node(1, "file.txt"),
			}
		)
	),
}
