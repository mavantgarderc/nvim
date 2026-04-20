local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"taskrun",
		fmt(
			[[
var result = await Task.Run(() =>
{{
  {body}
}});
  ]],
			{
				body = ls.insert_node(1, "// heavy work"),
			}
		)
	),
}
