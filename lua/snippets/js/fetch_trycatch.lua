local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"fet",
		fmt(
			[[
try {{
  const res = await fetch('{}');
  if (!res.ok) throw new Error('Request failed');
  const data = await res.json();
  console.log(data);
}} catch (err) {{
  console.error(err);
}}
]],
			{ i(1, "https://api.example.com") }
		)
	),
}
