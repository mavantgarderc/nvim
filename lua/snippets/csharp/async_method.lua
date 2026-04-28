local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"asyncm",
		fmt(
			[[
public async Task {Name}Async({params})
{{
  {body}
}}
  ]],
			{
				Name = ls.insert_node(1, "DoWork"),
				params = ls.insert_node(2, ""),
				body = ls.insert_node(3, "await Task.CompletedTask;"),
			}
		)
	),
}
