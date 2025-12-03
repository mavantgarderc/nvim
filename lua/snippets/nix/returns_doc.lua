local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ret",
		name = "Nix Returns Doc Section",
		desc = "Comment section for documenting return values in functions.",
	}, {
		t({ "#", "# Returns: " }),
		i(1, "Description of return value."),
	}),
}
