local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"efaddasync",
		fmt(
			[[
await _context.{Set}.AddAsync({entity});
await _context.SaveChangesAsync();
  ]],
			{
				Set = ls.insert_node(1, "Users"),
				entity = ls.insert_node(2, "user"),
			}
		)
	),
}
