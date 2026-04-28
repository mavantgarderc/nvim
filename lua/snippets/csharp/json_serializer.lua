local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jsonser",
		fmt(
			[[
var json = JsonSerializer.Serialize({obj});
  ]],
			{
				obj = ls.insert_node(1, "model"),
			}
		)
	),
}
