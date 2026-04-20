local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"deb",
		fmt(
			[[
function debounce(fn, delay) {{
  let timer;
  return (...args) => {{
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  }};
}}
]],
			{}
		)
	),
}
