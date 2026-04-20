local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"whenany",
		fmt(
			[[
var completed = await Task.WhenAny({tasks});
  ]],
			{
				tasks = ls.insert_node(1, "task1, task2"),
			}
		)
	),
}
