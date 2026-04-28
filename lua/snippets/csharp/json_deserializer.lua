local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jsondes",
		fmt(
			[[
var obj = JsonSerializer.Deserialize<{Type}>({json});
  ]],
			{
				Type = ls.insert_node(1, "MyType"),
				json = ls.insert_node(2, "json"),
			}
		)
	),
}
