local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"apikey",
		fmt(
			[[
public class ApiKeyMiddleware
{{
    private readonly RequestDelegate _next;
    private readonly string _header = "X-API-Key";
    private readonly string _key;

    public ApiKeyMiddleware(RequestDelegate next, string key)
    {{
        _next = next;
        _key = key;
    }}

    public async Task Invoke(HttpContext ctx)
    {{
        if (!ctx.Request.Headers.TryGetValue(_header, out var val) ||
            val != _key)
        {{
            ctx.Response.StatusCode = 401;
            return;
        }}

        await _next(ctx);
    }}
}}
  ]],
			{}
		)
	),
}
