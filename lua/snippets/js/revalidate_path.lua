local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"repath",
		fmt(
			[[
"use server";

import {{ revalidatePath }} from "next/cache";

export async function {action}() {{
  {logic}
  revalidatePath("{path}");
}}
  ]],
			{
				action = ls.insert_node(1, "updateData"),
				logic = ls.insert_node(2, "// update something"),
				path = ls.insert_node(3, "/"),
			}
		)
	),
}
