local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ct",
		fmt(
			[[
using var cts = new CancellationTokenSource();
CancellationToken token = cts.Token;
  ]],
			{}
		)
	),
}
