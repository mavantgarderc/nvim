local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"entity",
		fmt(
			[[
public class {Name}
{{
    public {IdType} Id {{ get; set; }}
    {body}
}}
  ]],
			{
				Name = ls.insert_node(1, "UserEntity"),
				IdType = ls.insert_node(2, "Guid"),
				body = ls.insert_node(3, "// properties"),
			}
		)
	),
}
