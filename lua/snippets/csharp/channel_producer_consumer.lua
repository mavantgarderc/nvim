local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"chanpc",
		fmt(
			[[
var channel = Channel.CreateBounded<int>({cap});

// producer
_ = Task.Run(async () =>
{{
    for (int i = 0; i < {count}; i++)
    {{
        await channel.Writer.WriteAsync(i);
    }}
    channel.Writer.Complete();
}});

// consumer
await foreach (var item in channel.Reader.ReadAllAsync())
{{
    Console.WriteLine(item);
}}
  ]],
			{
				cap = ls.insert_node(1, "100"),
				count = ls.insert_node(2, "1000"),
			}
		)
	),
}
