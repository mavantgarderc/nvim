local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"bullq",
		fmt(
			[[
const {{ Queue, Worker }} = require("bullmq");

const queue = new Queue("{name}", {{
  connection: {{
    host: "localhost",
    port: 6379
  }}
}});

new Worker("{name}", async (job) => {{
  {logic}
}});

module.exports = queue;
  ]],
			{
				name = ls.insert_node(1, "jobs"),
				logic = ls.insert_node(2, "// process job"),
			}
		)
	),
}
