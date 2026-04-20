local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ndyn",
		fmt(
			[[
export default function {Page}({args}) {{
  return <div>{content}</div>;
}}
  ]],
			{
				Page = ls.insert_node(1, "Page"),
				args = ls.insert_node(2, "{ params }"),
				content = ls.insert_node(3, "{params.id}"),
			}
		)
	),
}
