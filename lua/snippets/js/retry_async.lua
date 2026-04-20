local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"retry",
		fmt(
			[[
async function retry(fn, retries = 3) {{
  let lastError;
  for (let i = 0; i < retries; i++) {{
    try {{
      return await fn();
    }} catch (err) {{
      lastError = err;
    }}
  }}
  throw lastError;
}}
]],
			{}
		)
	),
}
