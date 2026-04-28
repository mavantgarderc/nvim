local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ngmeta",
		fmt(
			[[
export async function generateMetadata({args}) {{
  const {data} = await {fetcher}();
  return {{
    title: `{title}`,
    description: `{description}`
  }};
}}
  ]],
			{
				args = ls.insert_node(1, "{ params }"),
				data = ls.insert_node(2, "data"),
				fetcher = ls.insert_node(3, "getData"),
				title = ls.insert_node(4, "Dynamic Title"),
				description = ls.insert_node(5, "Dynamic description."),
			}
		)
	),
}
