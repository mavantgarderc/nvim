local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mock",
		fmt(
			[[
var mock = new Mock<{Type}>();
mock.Setup(x => x.{Method}({args})).Returns({returnValue});
  ]],
			{
				Type = ls.insert_node(1, "IMyService"),
				Method = ls.insert_node(2, "DoWork"),
				args = ls.insert_node(3, "It.IsAny<int>()"),
				returnValue = ls.insert_node(4, "true"),
			}
		)
	),
}
