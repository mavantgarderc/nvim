local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"singleton",
		fmt(
			[[
public sealed class {Name}
{{
    private static readonly Lazy<{Name}> _instance = new(() => new {Name}());

    private {Name}() {{ }}

    public static {Name} Instance => _instance.Value;
}}
  ]],
			{
				Name = ls.insert_node(1, "Singleton"),
			}
		)
	),
}
