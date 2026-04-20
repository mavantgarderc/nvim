local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pforeach",
		fmt(
			[[
await Parallel.ForEachAsync({collection}, async (item, ct) =>
{{
  {body}
}});
  ]],
			{
				collection = ls.insert_node(1, "items"),
				body = ls.insert_node(2, "// process item"),
			}
		)
	),
}
