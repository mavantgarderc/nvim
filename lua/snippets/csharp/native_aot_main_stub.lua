local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"aotmain",
		fmt(
			[[
using System.Runtime.InteropServices;

Console.WriteLine({msg});

// Ensure trimming-friendly
[DynamicDependency(DynamicallyAccessedMemberTypes.All, typeof(object))]
static partial class Keep {}
  ]],
			{
				msg = ls.insert_node(1, '"hello native aot"'),
			}
		)
	),
}
