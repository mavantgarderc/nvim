local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jsonreadfile",
		fmt(
			[[
var json = File.ReadAllText("{path}");
var obj = JsonSerializer.Deserialize<{Type}>(json);
  ]],
			{
				path = ls.insert_node(1, "data.json"),
				Type = ls.insert_node(2, "MyType"),
			}
		)
	),
}
