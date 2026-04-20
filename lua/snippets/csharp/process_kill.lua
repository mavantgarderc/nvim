local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"prockill",
		fmt(
			[[
var proc = Process.GetProcessById({pid});
proc.Kill(true);
  ]],
			{
				pid = ls.insert_node(1, "1234"),
			}
		)
	),
}
