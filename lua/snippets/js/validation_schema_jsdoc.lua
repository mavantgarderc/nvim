local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"vjs",
		fmt(
			[[
/**
 * @param {{ {} }} data
 * @throws {{Error}}
 */
function validate{}(data) {{
  if (!data.{}) throw new Error('{} is required');
}}
]],
			{
				i(1, "name: string"),
				i(2, "User"),
				i(3, "name"),
				i(4, "name"),
			}
		)
	),
}
