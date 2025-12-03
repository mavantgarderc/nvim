local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "optmd",
		name = "NixOS Option Markdown Description",
		desc = "Markdown-formatted description for NixOS options, supporting rich text as per manual.",
	}, {
		t('description = lib.mdDoc "'),
		i(1, "Brief description."),
		t({ '";', "" }),
	}),
}
