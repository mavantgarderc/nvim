local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jsonwritefile",
		fmt(
			[[
var json = JsonSerializer.Serialize({obj});
File.WriteAllText("{path}", json);
  ]],
			{
				obj = ls.insert_node(1, "model"),
				path = ls.insert_node(2, "data.json"),
			}
		)
	),
}
