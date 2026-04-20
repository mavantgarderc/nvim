local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"batchw",
		fmt(
			[[
var ch = Channel.CreateBounded<byte[]>(new BoundedChannelOptions(1024)
{{
    SingleWriter = false,
    SingleReader = true
}});

var writer = ch.Writer;
var batch = new List<byte[]>(capacity: {cap});

async Task ProduceAsync()
{{
    while (true)
    {{
        var msg = GetMsg();
        batch.Add(msg);

        if (batch.Count >= {batchsize})
        {{
            await writer.WriteAsync(batch.ToArray());
            batch.Clear();
        }}
    }}
}}
  ]],
			{
				cap = ls.insert_node(1, "64"),
				batchsize = ls.insert_node(2, "32"),
			}
		)
	),
}
