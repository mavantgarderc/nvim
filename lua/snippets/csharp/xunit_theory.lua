local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"theory",
		fmt(
			[[
[Theory]
[InlineData({values})]
public void {Name}({params})
{{
    {body}
}}
  ]],
			{
				values = ls.insert_node(1, '"a", 1'),
				Name = ls.insert_node(2, "TestMethod"),
				params = ls.insert_node(3, "string s, int n"),
				body = ls.insert_node(4, "// assert"),
			}
		)
	),
}
