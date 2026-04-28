local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"unsafeptr",
		fmt(
			[[
unsafe
{{
    int value = {val};
    int* p = &value;
    *p = *p + 1;
}}
  ]],
			{
				val = ls.insert_node(1, "42"),
			}
		)
	),
}
