local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"decorator",
		fmt(
			[[
public class {Name}Decorator : I{Interface}
{{
    private readonly I{Interface} _inner;

    public {Name}Decorator(I{Interface} inner)
    {{
        _inner = inner;
    }}

    public {ReturnType} {Method}()
    {{
        // pre-processing
        var result = _inner.{Method}();
        // post-processing
        return result;
    }}
}}
  ]],
			{
				Name = ls.insert_node(1, "Logging"),
				Interface = ls.insert_node(2, "Service"),
				ReturnType = ls.insert_node(3, "void"),
				Method = ls.insert_node(4, "Execute"),
			}
		)
	),
}
