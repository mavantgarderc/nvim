local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"batchr",
		fmt(
			[[
var reader = ch.Reader;

await foreach (var batch in reader.ReadAllAsync())
{{
    foreach (var msg in batch)
    {{
        // process msg
    }}
}}
  ]],
			{}
		)
	),
}
