local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mhand",
		fmt(
			[[
public class {Name}Handler : IRequestHandler<{Name}Command, {ReturnType}>
{{
    public async Task<{ReturnType}> Handle({Name}Command request, CancellationToken ct)
    {{
        {body}
    }}
}}
  ]],
			{
				Name = ls.insert_node(1, "CreateUser"),
				ReturnType = ls.insert_node(2, "Guid"),
				body = ls.insert_node(3, "return await Task.FromResult(Guid.NewGuid());"),
			}
		)
	),
}
