local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"queue",
		fmt(
			[[
var queue = new Queue<{T}>();
queue.Enqueue({v});
var next = queue.Dequeue();
  ]],
			{
				T = ls.insert_node(1, "int"),
				v = ls.insert_node(2, "42"),
			}
		)
	),
}
