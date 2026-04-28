local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"abus",
		fmt(
			[[
public class MessageBus<T>
{{
    private readonly Channel<T> _ch = Channel.CreateUnbounded<T>();

    public ValueTask PublishAsync(T item) => _ch.Writer.WriteAsync(item);

    public async Task SubscribeAsync(Func<T, Task> handler, CancellationToken ct)
    {{
        var reader = _ch.Reader;
        await foreach (var item in reader.ReadAllAsync(ct))
        {{
            await handler(item);
        }}
    }}
}}
  ]],
			{}
		)
	),
}
