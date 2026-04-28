local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"dto",
		fmt(
			[[
public record {Name}Dto({Params});
  ]],
			{
				Name = ls.insert_node(1, "User"),
				Params = ls.insert_node(2, "Guid Id, string Name"),
			}
		)
	),
}
