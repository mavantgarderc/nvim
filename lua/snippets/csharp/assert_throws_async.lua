local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"assthrowa",
		fmt(
			[[
await Assert.ThrowsAsync<{Exception}>(async () =>
{{
    {body}
}});
  ]],
			{
				Exception = ls.insert_node(1, "Exception"),
				body = ls.insert_node(2, "// await op"),
			}
		)
	),
}
