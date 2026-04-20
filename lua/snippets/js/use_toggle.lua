local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"utog",
		fmt(
			[[
function useToggle(initial = false) {{
  const [value, setValue] = React.useState(initial);
  const toggle = () => setValue(v => !v);
  return [value, toggle];
}}
]],
			{}
		)
	),
}
