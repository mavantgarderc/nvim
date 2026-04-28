local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"kfilter",
		fmt(
			[[
public class {name} : IEndpointFilter
{{
    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext ctx, EndpointFilterDelegate next)
    {{
        // before
        var result = await next(ctx);
        // after
        return result;
    }}
}

app.MapGet({route}, () => "ok")
   .AddEndpointFilter<{name}>();
  ]],
			{
				name = ls.insert_node(1, "LoggingFilter"),
				route = ls.insert_node(2, '"/ping"'),
			}
		)
	),
}
