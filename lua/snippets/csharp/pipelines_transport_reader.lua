local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pipetrans",
		fmt(
			[[
var pipe = new Pipe();
_ = Task.Run(async () =>
{{
    var writer = pipe.Writer;
    using var s = new Socket(SocketType.Stream, ProtocolType.Tcp);
    s.Connect({host}, {port});

    while (true)
    {{
        Memory<byte> mem = writer.GetMemory(1024);
        int read = s.Receive(mem.Span);
        if (read == 0) break;

        writer.Advance(read);
        var r = await writer.FlushAsync();
        if (r.IsCompleted) break;
    }}

    writer.Complete();
}});

// consumer
var reader = pipe.Reader;
while (true)
{{
    var result = await reader.ReadAsync();
    var buffer = result.Buffer;

    // process
    reader.AdvanceTo(buffer.End);

    if (result.IsCompleted) break;
}}
  ]],
			{
				host = ls.insert_node(1, '"localhost"'),
				port = ls.insert_node(2, "5000"),
			}
		)
	),
}
