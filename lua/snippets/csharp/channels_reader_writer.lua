local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"channel",
		fmt(
			[[
var channel = Channel.CreateUnbounded<{T}>();

var writer = Task.Run(async () =>
{{
    await channel.Writer.WriteAsync({val});
    channel.Writer.Complete();
}});

var reader = Task.Run(async () =>
{{
    await foreach (var item in channel.Reader.ReadAllAsync())
    {{
        {body}
    }}
}});
  ]],
			{
				T = ls.insert_node(1, "int"),
				val = ls.insert_node(2, "42"),
				body = ls.insert_node(3, "// process item"),
			}
		)
	),
}
