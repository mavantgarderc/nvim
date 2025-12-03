local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ex",
		name = "Examples Section",
		desc = "Inserts an Examples section with a code block.",
	}, {
		t({ "", "Examples:", "    " }),
		i(1, "Description of example."),
		t({ "", "", "    >>> " }),
		i(2, "code_example()"),
		t({ "", "    expected_output" }),
	}),
}
