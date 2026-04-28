local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"kconnraw",
		fmt(
			[[
public class {handler} : ConnectionHandler
{{
    public override async Task OnConnectedAsync(ConnectionContext ctx)
    {{
        var reader = ctx.Transport.Input;
        var writer = ctx.Transport.Output;

        while (true)
        {{
            var result = await reader.ReadAsync();
            var buffer = result.Buffer;

            foreach (var seg in buffer)
            {{
                // inspect raw bytes
            }}

            reader.AdvanceTo(buffer.End);

            if (result.IsCompleted) break;
        }}
    }}
}

app.UseConnectionHandler<{handler}>();
  ]],
			{
				handler = ls.insert_node(1, "RawConnHandler"),
			}
		)
	),
}
