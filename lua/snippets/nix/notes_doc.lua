local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "not",
		name = "Nix Notes Doc Section",
		desc = "Comment section for additional notes in documentation.",
	}, {
		t({ "#", "# Notes: " }),
		i(1, "Additional notes or caveats."),
	}),
}
