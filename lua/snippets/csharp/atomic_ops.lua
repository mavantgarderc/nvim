local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"atomic",
		fmt(
			[[
int v = 0;

Interlocked.Increment(ref v);
Interlocked.Decrement(ref v);
Interlocked.CompareExchange(ref v, {newv}, {oldv});
Interlocked.Exchange(ref v, {val});
  ]],
			{
				newv = ls.insert_node(1, "10"),
				oldv = ls.insert_node(2, "0"),
				val = ls.insert_node(3, "5"),
			}
		)
	),
}
