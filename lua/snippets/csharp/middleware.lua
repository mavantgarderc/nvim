local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"middleware",
		fmt(
			[[
public class {Name}Middleware
{{
    private readonly RequestDelegate _next;

    public {Name}Middleware(RequestDelegate next) => _next = next;

    public async Task InvokeAsync(HttpContext context)
    {{
        {body}
        await _next(context);
    }}
}}
  ]],
			{
				Name = ls.insert_node(1, "Custom"),
				body = ls.insert_node(2, "// logic"),
			}
		)
	),
}
