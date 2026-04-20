local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ngsp",
		fmt(
			[[
export async function generateStaticParams() {{
  const items = await {fetcher}();
  return items.map((item) => ({
    {key}: item.{key}
  }));
}}
  ]],
			{
				fetcher = ls.insert_node(1, "getItems"),
				key = ls.insert_node(2, "id"),
			}
		)
	),
}
