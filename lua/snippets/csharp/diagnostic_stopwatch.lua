local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"stopwatch",
		fmt(
			[[
var sw = Stopwatch.StartNew();

{body}

sw.Stop();
Console.WriteLine($"Elapsed: {{sw.ElapsedMilliseconds}} ms");
  ]],
			{
				body = ls.insert_node(1, "// work"),
			}
		)
	),
}
