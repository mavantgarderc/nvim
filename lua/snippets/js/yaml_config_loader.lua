local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"lyaml",
		fmt(
			[[
import fs from 'fs';
import yaml from 'js-yaml';

const config = yaml.load(fs.readFileSync('{}', 'utf8'));
export default config;
]],
			{ i(1, "config.yaml") }
		)
	),
}
