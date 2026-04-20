local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"classfix",
		fmt(
			[[
public class {TestClass} : IClassFixture<{Fixture}>
{{
    private readonly {Fixture} _fixture;

    public {TestClass}({Fixture} fixture)
    {{
        _fixture = fixture;
    }}

    {body}
}}
  ]],
			{
				TestClass = ls.insert_node(1, "MyTests"),
				Fixture = ls.insert_node(2, "AppFixture"),
				body = ls.insert_node(3, "// tests"),
			}
		)
	),
}
