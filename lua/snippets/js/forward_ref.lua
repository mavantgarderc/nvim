local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"fref",
		fmt(
			[[
const {Component} = React.forwardRef(({props}, ref) => {{
  {body}
}});
  ]],
			{
				Component = ls.insert_node(1, "MyComponent"),
				props = ls.insert_node(2, "props"),
				body = ls.insert_node(3, "return <div ref={ref} />"),
			}
		)
	),
}
