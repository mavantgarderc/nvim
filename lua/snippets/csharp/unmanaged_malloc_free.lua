local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mallocfree",
		fmt(
			[[
IntPtr ptr = Marshal.AllocHGlobal({size});
try
{{
    // use ptr
}}
finally
{{
    Marshal.FreeHGlobal(ptr);
}}
  ]],
			{
				size = ls.insert_node(1, "256"),
			}
		)
	),
}
