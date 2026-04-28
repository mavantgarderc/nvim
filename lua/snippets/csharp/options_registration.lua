local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"optsreg",
		fmt(
			[[
builder.Services.Configure<{Options}>(builder.Configuration.GetSection("{Section}"));
  ]],
			{
				Options = ls.insert_node(1, "MyOptions"),
				Section = ls.insert_node(2, "MyOptions"),
			}
		)
	),
}
