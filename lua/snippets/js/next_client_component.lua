local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nclient",
		fmt(
			[[
'use client';

export default function {}() {{
  {}
  return <div>{}</div>;
}}
]],
			{
				i(1, "Component"),
				i(2, "// client logic"),
				i(3, "content"),
			}
		)
	),
}
