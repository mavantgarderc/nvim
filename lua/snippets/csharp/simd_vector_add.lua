local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"simdadd",
		fmt(
			[[
var a = new Vector<float>(new float[] {{ {a} }});
var b = new Vector<float>(new float[] {{ {b} }});
var c = a + b;
  ]],
			{
				a = ls.insert_node(1, "1,2,3,4"),
				b = ls.insert_node(2, "5,6,7,8"),
			}
		)
	),
}
