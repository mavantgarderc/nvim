local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"envvars",
		fmt(
			[[
var value = Environment.GetEnvironmentVariable("{key}");
Environment.SetEnvironmentVariable("{setKey}", "{setValue}");
  ]],
			{
				key = ls.insert_node(1, "PATH"),
				setKey = ls.insert_node(2, "MY_KEY"),
				setValue = ls.insert_node(3, "123"),
			}
		)
	),
}
