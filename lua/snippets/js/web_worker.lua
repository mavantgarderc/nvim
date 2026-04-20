local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"worker",
		fmt(
			[[
const worker = new Worker('{}');

worker.onmessage = (event) => {{
  {}
}};

worker.postMessage({});
]],
			{
				i(1, "worker.js"),
				i(2, "// handle result"),
				i(3, "data"),
			}
		)
	),
}
