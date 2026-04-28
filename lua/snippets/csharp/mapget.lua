local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mapget",
		fmt(
			[[
app.MapGet("{route}", async () =>
{{
    {body}
}});
  ]],
			{
				route = ls.insert_node(1, "/items"),
				body = ls.insert_node(2, "return Results.Ok();"),
			}
		)
	),
}
