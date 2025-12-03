local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "trigdoc",
		name = "SQL Trigger Doc Comment",
		desc = "Multi-line comment block for documenting a trigger.",
	}, {
		t({ "/**", " * Trigger: " }),
		i(1, "TriggerName"),
		t({ "", " *", " * Description: " }),
		i(2, "Brief description of the trigger."),
		t({ "", " *", " * On: " }),
		i(3, "TableName"),
		t({ "", " * For: " }),
		i(4, "INSERT/UPDATE/DELETE"),
		t({ "", " *", " * Example:", " *   " }),
		i(5, "Action that fires the trigger."),
		t({ "", " */" }),
	}),
}
