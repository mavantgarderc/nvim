local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"opoolpol",
		fmt(
			[[
public class {name} : IPooledObjectPolicy<{type}>
{{
    public {type} Create() => new {type}();

    public bool Return({type} obj)
    {{
        // reset
        return true;
    }}
}}

var pool = new DefaultObjectPool<{type}>(new {name}());
var item = pool.Get();
pool.Return(item);
  ]],
			{
				name = ls.insert_node(1, "MyPolicy"),
				type = ls.insert_node(2, "MyReusable"),
			}
		)
	),
}
