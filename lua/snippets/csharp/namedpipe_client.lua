local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"npclient",
		fmt(
			[[
using var pipe = new NamedPipeClientStream(".", {name}, PipeDirection.InOut,
    PipeOptions.Asynchronous);

await pipe.ConnectAsync();

var writer = PipeWriter.Create(pipe);
var mem = writer.GetMemory(128);

Encoding.UTF8.GetBytes({msg}, mem.Span);
writer.Advance({len});
await writer.FlushAsync();
  ]],
			{
				name = ls.insert_node(1, '"mava_pipe"'),
				msg = ls.insert_node(2, '"hello pipe"'),
				len = ls.insert_node(3, "10"),
			}
		)
	),
}
