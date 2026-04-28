local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"bgservice",
		fmt(
			[[
public class {Name} : BackgroundService
{{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {{
        while (!stoppingToken.IsCancellationRequested)
        {{
            {body}
            await Task.Delay({delay}, stoppingToken);
        }}
    }}
}}
  ]],
			{
				Name = ls.insert_node(1, "Worker"),
				body = ls.insert_node(2, "// do work"),
				delay = ls.insert_node(3, "1000"),
			}
		)
	),
}
