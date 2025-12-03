local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ptdl",
		name = "PyTorch DataLoader Usage Docstring",
		desc = "Docstring for functions that create DataLoaders.",
	}, {
		t({ '"""', "" }),
		i(1, "Creates a DataLoader for the dataset."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "dataset : Dataset" }),
		t({ "", "    The dataset from which to load the data." }),
		t({ "", "batch_size : int, optional" }),
		t({ "", "    How many samples per batch to load. Default: 32." }),
		t({ "", "shuffle : bool, optional" }),
		t({ "", "    Set to True to have the data reshuffled at every epoch. Default: True." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "DataLoader" }),
		t({ "", "    DataLoader object." }),
		t({ "", '"""' }),
	}),
}
