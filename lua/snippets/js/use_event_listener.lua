local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"uel",
		fmt(
			[[
function useEventListener(event, handler, element = window) {{
  React.useEffect(() => {{
    element.addEventListener(event, handler);
    return () => element.removeEventListener(event, handler);
  }}, [event, element, handler]);
}}
]],
			{}
		)
	),
}
