local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"fetch",
		fmt(
			[[
const res = await fetch('{}');
const data = await res.json();
console.log(data);
]],
			{ i(1, "https://api.example.com") }
		)
	),
}
