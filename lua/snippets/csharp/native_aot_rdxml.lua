local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"aotxml",
		fmt(
			[[
<Directives>
  <Assembly Name="{assembly}">
    <Type Name="{type}" Dynamic="Required All"/>
  </Assembly>
</Directives>
  ]],
			{
				assembly = ls.insert_node(1, "MyApp"),
				type = ls.insert_node(2, "MyType"),
			}
		)
	),
}
