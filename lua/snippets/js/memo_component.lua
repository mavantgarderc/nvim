local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rmemo",
		fmt(
			[[
const {Name} = React.memo(function {Name}({props}) {{
  {body}
}});
  ]],
			{
				Name = ls.insert_node(1, "Component"),
				props = ls.insert_node(2, "props"),
				body = ls.insert_node(3, "return <div />"),
			}
		)
	),
}
