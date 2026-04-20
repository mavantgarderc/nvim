local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sse2add",
		fmt(
			[[
if (Sse2.IsSupported)
{{
    var v1 = Vector128.Create({a});
    var v2 = Vector128.Create({b});
    var v3 = Sse2.Add(v1, v2);
}}
  ]],
			{
				a = ls.insert_node(1, "1,1,1,1"),
				b = ls.insert_node(2, "2,2,2,2"),
			}
		)
	),
}
