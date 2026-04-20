local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cts",
		fmt(
			[[
using var cts = new CancellationTokenSource();
cts.CancelAfter({ms});
var token = cts.Token;

{body}
  ]],
			{
				ms = ls.insert_node(1, "5000"),
				body = ls.insert_node(2, "// pass token into async calls"),
			}
		)
	),
}
