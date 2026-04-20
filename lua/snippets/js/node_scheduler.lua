local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cron",
		fmt(
			[[
const cron = require("node-cron");

cron.schedule("{pattern}", async () => {{
  {logic}
}});
  ]],
			{
				pattern = ls.insert_node(1, "0 * * * *"), -- every hour
				logic = ls.insert_node(2, "// scheduled work"),
			}
		)
	),
}
