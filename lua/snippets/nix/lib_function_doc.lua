local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "lfd",
		name = "Nixpkgs Lib Function Doc",
		desc = "Documentation for custom lib functions, using comment and description if applicable.",
	}, {
		t({ "# lib." }),
		i(1, "functionName"),
		t({ ": " }),
		i(2, "Brief description."),
		t({ "", "#", "# Args:", "# - arg1: Type - Description." }),
		t({ "", "#", "# Returns: Type - Description." }),
	}),
}
