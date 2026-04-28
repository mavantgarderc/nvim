local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pinvoke",
		fmt(
			[[
[DllImport({dll}, EntryPoint = {fn}, CallingConvention = CallingConvention.Cdecl)]
public static extern int {method}(int x, int y);

// usage
int r = {method}(1, 2);
  ]],
			{
				dll = ls.insert_node(1, '"native.dll"'),
				fn = ls.insert_node(2, '"add"'),
				method = ls.insert_node(3, "Add"),
			}
		)
	),
}
