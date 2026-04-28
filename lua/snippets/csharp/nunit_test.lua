local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"nunit",
		fmt(
			[[
[Test]
public void {Name}()
{{
    {body}
}}
  ]],
			{
				Name = ls.insert_node(1, "TestMethod"),
				body = ls.insert_node(2, "// assert"),
			}
		)
	),
}
