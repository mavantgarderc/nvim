local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"attrdef",
		fmt(
			[[
[AttributeUsage(AttributeTargets.{target}, AllowMultiple = {multi})]
public class {Name}Attribute : Attribute
{{
    public {Name}Attribute({params})
    {{
        {body}
    }}
}}
  ]],
			{
				target = ls.insert_node(1, "Class"),
				multi = ls.insert_node(2, "false"),
				Name = ls.insert_node(3, "MyAttr"),
				params = ls.insert_node(4, ""),
				body = ls.insert_node(5, ""),
			}
		)
	),
}
