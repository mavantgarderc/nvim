local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"srvact",
		fmt(
			[[
"use server";
// server action: {name}
async function {name}({args}) {{
  {body}
}}
  ]],
			{
				name = ls.insert_node(1, "actionName"),
				args = ls.insert_node(2, "formData"),
				body = ls.insert_node(3, "// server logic"),
			}
		)
	),
}
