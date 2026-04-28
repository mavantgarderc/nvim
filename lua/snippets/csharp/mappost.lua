local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mappost",
		fmt(
			[[
app.MapPost("{route}", async ({params}) =>
{{
    {body}
}});
  ]],
			{
				route = ls.insert_node(1, "/items"),
				params = ls.insert_node(2, ""),
				body = ls.insert_node(3, 'return Results.Created("/items/1", null);'),
			}
		)
	),
}
