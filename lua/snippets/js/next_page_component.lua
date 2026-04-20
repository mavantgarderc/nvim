local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"npage",
		fmt(
			[[
export default function {}() {{
  return (
    <div>
      {}
    </div>
  );
}}
]],
			{ i(1, "Page"), i(2) }
		)
	),
}
