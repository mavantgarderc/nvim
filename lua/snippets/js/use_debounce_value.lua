local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"udeb",
		fmt(
			[[
function useDebounce(value, delay) {{
  const [debounced, setDebounced] = React.useState(value);

  React.useEffect(() => {{
    const id = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(id);
  }}, [value, delay]);

  return debounced;
}}
]],
			{}
		)
	),
}
