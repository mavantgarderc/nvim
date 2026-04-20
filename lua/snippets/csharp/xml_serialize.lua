local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"xmlser",
		fmt(
			[[
var serializer = new XmlSerializer(typeof({Type}));

using var stream = File.Create("{path}");
serializer.Serialize(stream, {obj});
  ]],
			{
				Type = ls.insert_node(1, "MyType"),
				path = ls.insert_node(2, "data.xml"),
				obj = ls.insert_node(3, "model"),
			}
		)
	),
}
