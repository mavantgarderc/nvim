local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"susp",
		fmt(
			[[
<Suspense fallback={<{Fallback} />}>
  <{Component} />
</Suspense>
  ]],
			{
				Fallback = ls.insert_node(1, "Loading"),
				Component = ls.insert_node(2, "MyComponent"),
			}
		)
	),
}
