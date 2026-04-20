local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"nsc",
		fmt(
			[[
export default async function {Page}() {{
  const data = await {fetcher}();
  return (
    <div>
      {body}
    </div>
  );
}}
  ]],
			{
				Page = ls.insert_node(1, "Page"),
				fetcher = ls.insert_node(2, "getData"),
				body = ls.insert_node(3, "{/* UI */}"),
			}
		)
	),
}
