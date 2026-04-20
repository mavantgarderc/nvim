local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"readtext",
		fmt(
			[[
var content = File.ReadAllText("{path}");
  ]],
			{
				path = ls.insert_node(1, "file.txt"),
			}
		)
	),
}
