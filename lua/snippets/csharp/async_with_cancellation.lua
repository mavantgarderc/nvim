local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"asyncc",
		fmt(
			[[
public async Task {Name}Async(CancellationToken cancellationToken)
{{
  {body}
}}
  ]],
			{
				Name = ls.insert_node(1, "DoWork"),
				body = ls.insert_node(2, "await Task.Delay(1000, cancellationToken);"),
			}
		)
	),
}
