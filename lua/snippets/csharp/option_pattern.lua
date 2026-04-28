local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"opts",
		fmt(
			[[
public class {Options}
{{
    public string {Prop} {{ get; set; }} = string.Empty;
}}
  ]],
			{
				Options = ls.insert_node(1, "MyOptions"),
				Prop = ls.insert_node(2, "Value"),
			}
		)
	),
}
