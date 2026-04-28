local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"strategy",
		fmt(
			[[
public interface I{Strategy}Strategy
{{
    {ReturnType} Execute({Params});
}}

public class {Concrete}Strategy : I{Strategy}Strategy
{{
    public {ReturnType} Execute({Params})
    {{
        {body}
    }}
}}
  ]],
			{
				Strategy = ls.insert_node(1, "Calculation"),
				ReturnType = ls.insert_node(2, "void"),
				Params = ls.insert_node(3, ""),
				Concrete = ls.insert_node(4, "Default"),
				body = ls.insert_node(5, "// implementation"),
			}
		)
	),
}
