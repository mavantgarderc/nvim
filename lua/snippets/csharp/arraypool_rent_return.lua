local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"apool",
		fmt(
			[[
var pool = ArrayPool<byte>.Shared;
byte[] buffer = pool.Rent({size});

try
{{
    // use buffer[..]
}}
finally
{{
    pool.Return(buffer, clearArray: {clear});
}}
  ]],
			{
				size = ls.insert_node(1, "4096"),
				clear = ls.insert_node(2, "false"),
			}
		)
	),
}
