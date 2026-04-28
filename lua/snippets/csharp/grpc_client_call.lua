local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"grpccall",
		fmt(
			[[
var channel = GrpcChannel.ForAddress("{url}");
var client = new {Service}.{Service}Client(channel);

var response = await client.{Method}Async(new {Request}
{{
    {fields}
}});
  ]],
			{
				url = ls.insert_node(1, "https://localhost:5001"),
				Service = ls.insert_node(2, "Greeter"),
				Method = ls.insert_node(3, "SayHello"),
				Request = ls.insert_node(4, "HelloRequest"),
				fields = ls.insert_node(5, 'Name = "Mava"'),
			}
		)
	),
}
