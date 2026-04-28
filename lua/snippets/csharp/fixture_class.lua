local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"fixture",
		fmt(
			[[
public class {Name}Fixture : IDisposable
{{
    public {Name}Fixture()
    {{
        {setup}
    }}

    public void Dispose()
    {{
        {dispose}
    }}
}}
  ]],
			{
				Name = ls.insert_node(1, "App"),
				setup = ls.insert_node(2, "// init"),
				dispose = ls.insert_node(3, "// cleanup"),
			}
		)
	),
}
