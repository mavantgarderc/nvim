local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"uprev",
		fmt(
			[[
function usePrevious(value) {{
  const ref = React.useRef();
  React.useEffect(() => {{
    ref.current = value;
  }}, [value]);
  return ref.current;
}}
]],
			{}
		)
	),
}
