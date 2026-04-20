local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"thr",
		fmt(
			[[
function throttle(fn, delay) {{
  let last = 0;
  return (...args) => {{
    const now = Date.now();
    if (now - last >= delay) {{
      last = now;
      fn(...args);
    }}
  }};
}}
]],
			{}
		)
	),
}
