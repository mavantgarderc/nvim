local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"stack",
		fmt(
			[[
var stack = new Stack<{T}>();
stack.Push({v});
var next = stack.Pop();
  ]],
			{
				T = ls.insert_node(1, "int"),
				v = ls.insert_node(2, "99"),
			}
		)
	),
}
