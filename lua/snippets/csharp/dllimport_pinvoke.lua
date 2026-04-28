local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pinvoke",
		fmt(
			[[
[DllImport({lib}, EntryPoint = {func}, CallingConvention = CallingConvention.Cdecl)]
public static extern int Add(int a, int b);

int result = Add(2, 3);
  ]],
			{
				lib = ls.insert_node(1, '"native.dll"'),
				func = ls.insert_node(2, '"add"'),
			}
		)
	),
}
