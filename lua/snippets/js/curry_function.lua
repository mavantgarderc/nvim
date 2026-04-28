local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"curry",
		fmt(
			[[
function curry(fn) {{
  return function curried(...args) {{
    if (args.length >= fn.length) {{
      return fn(...args);
    }}
    return (...more) => curried(...args, ...more);
  }};
}}
]],
			{}
		)
	),
}
