local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"nogc",
		fmt(
			[[
if (GC.TryStartNoGCRegion({bytes}))
{{
    try
    {{
        // critical work here
    }}
    finally
    {{
        GC.EndNoGCRegion();
    }}
}}
  ]],
			{
				bytes = ls.insert_node(1, "16 * 1024 * 1024"),
			}
		)
	),
}
