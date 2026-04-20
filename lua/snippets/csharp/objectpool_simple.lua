local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"opool",
		fmt(
			[[
var policy = new DefaultPooledObjectPolicy<{type}>();
var pool = new DefaultObjectPool<{type}>(policy, {max});

var obj = pool.Get();
try
{{
    // use obj
}}
finally
{{
    pool.Return(obj);
}}
  ]],
			{
				type = ls.insert_node(1, "StringBuilder"),
				max = ls.insert_node(2, "32"),
			}
		)
	),
}
