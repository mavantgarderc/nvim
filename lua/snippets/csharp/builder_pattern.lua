local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"builder",
		fmt(
			[[
public class {Name}Builder
{{
    private readonly {Target} _instance = new();

    public {Name}Builder With{Prop}({Type} value)
    {{
        _instance.{Prop} = value;
        return this;
    }}

    public {Target} Build() => _instance;
}}
  ]],
			{
				Name = ls.insert_node(1, "User"),
				Target = ls.insert_node(2, "UserEntity"),
				Prop = ls.insert_node(3, "Name"),
				Type = ls.insert_node(4, "string"),
			}
		)
	),
}
