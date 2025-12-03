-- csharp/code.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "code",
		name = "Code Doc Comment",
		desc = "Adds a <code> XML documentation comment for code examples.",
	}, {
		t("/// <code>"),
		t({ "", "/// " }),
		i(1, "source code or output"),
		t({ "", "/// </code>" }),
	}),
}
