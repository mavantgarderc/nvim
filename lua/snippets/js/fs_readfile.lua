local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"rff",
		fmt(
			[[
const fs = require('fs');

fs.readFile('{}', 'utf8', (err, data) => {{
  if (err) {{
    console.error(err);
    return;
  }}
  console.log(data);
}});
]],
			{ i(1, "path/to/file.txt") }
		)
	),
}
