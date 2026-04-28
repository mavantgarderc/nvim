local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pipe",
		fmt(
			[[
const fs = require("fs");
const {{ pipeline }} = require("stream/promises");

async function {Name}(input, output) {{
  await pipeline(
    fs.createReadStream(input),
    {transform},
    fs.createWriteStream(output)
  );
}}

module.exports = {Name};
  ]],
			{
				Name = ls.insert_node(1, "processFile"),
				transform = ls.insert_node(2, "// Transform stream"),
			}
		)
	),
}
