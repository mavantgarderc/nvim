local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"retag",
		fmt(
			[[
import {{ revalidateTag }} from "next/cache";

export async function {Name}() {{
  revalidateTag("{tag}");
}}
  ]],
			{
				Name = ls.insert_node(1, "action"),
				tag = ls.insert_node(2, "posts"),
			}
		)
	),
}
