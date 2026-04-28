local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"refinvoke",
		fmt(
			[[
var obj = new {Type}();
var method = typeof({Type}).GetMethod("{name}");
method!.Invoke(obj, new object?[] {{ {args} }});
  ]],
			{
				Type = ls.insert_node(1, "MyClass"),
				name = ls.insert_node(2, "DoWork"),
				args = ls.insert_node(3, ""),
			}
		)
	),
}
