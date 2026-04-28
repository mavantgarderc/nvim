local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"wff",
		fmt(
			[[
const fs = require('fs');

fs.writeFile('{}', '{}', (err) => {{
  if (err) {{
    console.error(err);
    return;
  }}
  console.log('File written');
}});
]],
			{ i(1, "file.txt"), i(2, "content") }
		)
	),
}
