local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"stream",
		fmt(
			[[
import {{ Suspense }} from "react";

export default function Page() {{
  return (
    <Suspense fallback={<{Fallback} />}>
      <AsyncContent />
    </Suspense>
  );
}}

async function AsyncContent() {{
  const data = await {fetcher}();
  return <div>{content}</div>;
}}
  ]],
			{
				Fallback = ls.insert_node(1, "Loading"),
				fetcher = ls.insert_node(2, "getData"),
				content = ls.insert_node(3, "data"),
			}
		)
	),
}
