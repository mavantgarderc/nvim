local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"ljson",
		fmt(
			[[
import fs from 'fs';

const config = JSON.parse(fs.readFileSync('{}', 'utf-8'));
export default config;
]],
			{ i(1, "config.json") }
		)
	),
}
