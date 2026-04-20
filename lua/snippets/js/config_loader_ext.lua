local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cfgx",
		fmt(
			[[
const fs = require("fs");

function loadConfig({path}, validate = (x) => x) {{
  const base = JSON.parse(fs.readFileSync({path}, "utf8"));
  const env = process.env;
  const merged = {{ ...base, ...env }};
  return validate(merged);
}}

module.exports = loadConfig;
  ]],
			{
				path = ls.insert_node(1, "'./config.json'"),
			}
		)
	),
}
