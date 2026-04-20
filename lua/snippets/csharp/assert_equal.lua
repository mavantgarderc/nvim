local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"asseq",
		fmt(
			[[
Assert.Equal({expected}, {actual});
  ]],
			{
				expected = ls.insert_node(1, "expected"),
				actual = ls.insert_node(2, "actual"),
			}
		)
	),
}
