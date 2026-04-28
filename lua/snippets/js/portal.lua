local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"prt",
		fmt(
			[[
ReactDOM.createPortal(
  <{Node} />,
  document.getElementById("{id}")
)
  ]],
			{
				Node = ls.insert_node(1, "div"),
				id = ls.insert_node(2, "portal-root"),
			}
		)
	),
}
