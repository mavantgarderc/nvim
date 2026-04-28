local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"usemid",
		fmt(
			[[
app.UseMiddleware<{Name}Middleware>();
  ]],
			{
				Name = ls.insert_node(1, "Custom"),
			}
		)
	),
}
