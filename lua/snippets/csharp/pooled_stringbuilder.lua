local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sbpool",
		fmt(
			[[
var pool = new DefaultObjectPool<StringBuilder>(new StringBuilderPooledObjectPolicy());

var sb = pool.Get();
try
{{
    sb.Append({text});
    var output = sb.ToString();
}}
finally
{{
    sb.Clear();
    pool.Return(sb);
}}
  ]],
			{
				text = ls.insert_node(1, '"hello pooled world"'),
			}
		)
	),
}
