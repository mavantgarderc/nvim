local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"uid",
		fmt(
			[[
const {id} = React.useId();
  ]],
			{
				id = ls.insert_node(1, "id"),
			}
		)
	),
}
