local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rsm",
		fmt(
			[[
<React.StrictMode>
  <{Component} />
</React.StrictMode>
  ]],
			{
				Component = ls.insert_node(1, "App"),
			}
		)
	),
}
