local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"kconnmid",
		fmt(
			[[
app.Use(async (context, next) =>
{{
    // Connection-level intercept
    var conn = context.Connection;
    Console.WriteLine($"Conn: {{conn.RemoteIpAddress}}");

    await next(context);
}});
  ]],
			{}
		)
	),
}
