local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"diservice",
		fmt(
			[[
public static class {Name}Extensions
{{
    public static IServiceCollection Add{Name}Services(this IServiceCollection services)
    {{
        services.AddScoped<I{Service}, {Service}>();
        return services;
    }}
}}
  ]],
			{
				Name = ls.insert_node(1, "Feature"),
				Service = ls.insert_node(2, "MyService"),
			}
		)
	),
}
