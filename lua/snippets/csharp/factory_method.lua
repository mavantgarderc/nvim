local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"factory",
		fmt(
			[[
public abstract class {Creator}
{{
    public abstract {IProduct} Create();
}}

public class {ConcreteCreator} : {Creator}
{{
    public override {IProduct} Create() => new {ConcreteProduct}();
}}
  ]],
			{
				Creator = ls.insert_node(1, "Creator"),
				IProduct = ls.insert_node(2, "IProduct"),
				ConcreteCreator = ls.insert_node(3, "ConcreteCreator"),
				ConcreteProduct = ls.insert_node(4, "ConcreteProduct"),
			}
		)
	),
}
