local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"retry",
		fmt(
			[[
for (int i = 0; i < {retries}; i++)
{{
  try
  {{
    {body}
    break;
  }}
  catch when (i < {retries} - 1)
  {{
    await Task.Delay({delay});
  }}
}}
  ]],
			{
				retries = ls.insert_node(1, "3"),
				delay = ls.insert_node(2, "500"),
				body = ls.insert_node(3, "// attempt"),
			}
		)
	),
}
