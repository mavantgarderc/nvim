local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"apigroup",
		fmt(
			[[
var {group} = app.MapGroup("{route}");
{group}.MapGet("/", () => "OK");
  ]],
			{
				group = ls.insert_node(1, "users"),
				route = ls.insert_node(2, "/users"),
			}
		)
	),
}
