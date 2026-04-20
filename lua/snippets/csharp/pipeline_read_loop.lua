local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"piperead",
		fmt(
			[[
var pipe = new Pipe();

_ = Task.Run(async () =>
{{
    var writer = pipe.Writer;
    await writer.WriteAsync(Encoding.UTF8.GetBytes({text}));
    writer.Complete();
}});

var reader = pipe.Reader;

while (true)
{{
    var result = await reader.ReadAsync();
    var buffer = result.Buffer;

    foreach (var segment in buffer)
    {{
        var chunk = Encoding.UTF8.GetString(segment.Span);
        Console.Write(chunk);
    }}

    reader.AdvanceTo(buffer.End);

    if (result.IsCompleted)
        break;
}}

reader.Complete();
  ]],
			{
				text = ls.insert_node(1, '"hello pipelines"'),
			}
		)
	),
}
