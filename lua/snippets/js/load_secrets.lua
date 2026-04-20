local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"secrets",
		fmt(
			[[
const fs = require("fs");
const path = require("path");

function loadSecrets(schema) {{
  const p = path.join(process.cwd(), "{file}");
  const raw = JSON.parse(fs.readFileSync(p, "utf8"));
  return schema.parse(raw);
}}

module.exports = loadSecrets;
  ]],
			{
				file = ls.insert_node(1, "secrets.json"),
			}
		)
	),
}
