local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"lock",
		fmt(
			[[
lock ({obj})
{{
    {body}
}}
  ]],
			{
				obj = ls.insert_node(1, "_lock"),
				body = ls.insert_node(2, "// work"),
			}
		)
	),
}
