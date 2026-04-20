local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"semslim",
		fmt(
			[[
var semaphore = new SemaphoreSlim({initial}, {max});

await semaphore.WaitAsync();
try
{{
    {body}
}}
finally
{{
    semaphore.Release();
}}
  ]],
			{
				initial = ls.insert_node(1, "1"),
				max = ls.insert_node(2, "1"),
				body = ls.insert_node(3, "// do work"),
			}
		)
	),
}
