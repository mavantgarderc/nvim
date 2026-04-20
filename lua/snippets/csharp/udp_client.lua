local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"udpclient",
		fmt(
			[[
using var udp = new UdpClient();

var data = Encoding.UTF8.GetBytes({msg});
await udp.SendAsync(data, data.Length, "{host}", {port});

var result = await udp.ReceiveAsync();
var text = Encoding.UTF8.GetString(result.Buffer);
  ]],
			{
				msg = ls.insert_node(1, '"hello"'),
				host = ls.insert_node(2, "localhost"),
				port = ls.insert_node(3, "9000"),
			}
		)
	),
}
