local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptds",
    name = "PyTorch Dataset Class Docstring",
    desc = "Docstring for custom Dataset classes.",
  }, {
    t({ '"""', "" }),
    i(1, "Custom dataset for loading data."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "root_dir : str" }),
    t({ "", "    Directory with all the data." }),
    t({ "", "transform : callable, optional" }),
    t({ "", "    Optional transform to be applied on a sample." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "samples : list" }),
    t({ "", "    List of samples." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "__len__()" }),
    t({ "", "    Returns the size of the dataset." }),
    t({ "", "__getitem__(idx)" }),
    t({ "", "    Returns a sample from the dataset." }),
    t({ "", '"""' }),
  }),
}
