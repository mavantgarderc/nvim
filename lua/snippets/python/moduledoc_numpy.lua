local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmdoc",
		name = "NumPy Module Docstring",
		desc = "NumPy-style docstring for modules.",
	}, {
		t({ '"""', "" }),
		i(1, "Short description of the module."),
		t({ "", "", "Extended description.", "", "Functions", "---------" }),
		t({ "", "" }),
		i(2, "function_name"),
		t({ "", "    Short description." }),
		t({ "", '"""' }),
	}),
}
