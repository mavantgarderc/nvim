local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"resp",
		fmt(
			[[
function response(success, data, message = null) {{
  return {{
    success,
    data,
    message
  }};
}}
]],
			{}
		)
	),
}
