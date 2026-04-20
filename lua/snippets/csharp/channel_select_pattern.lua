local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"chanselect",
		fmt(
			[[
var c1 = Channel.CreateUnbounded<int>();
var c2 = Channel.CreateUnbounded<string>();

await Task.WhenAny(
    Task.Run(async () => Console.WriteLine(await c1.Reader.ReadAsync())),
    Task.Run(async () => Console.WriteLine(await c2.Reader.ReadAsync()))
);
  ]],
			{}
		)
	),
}
