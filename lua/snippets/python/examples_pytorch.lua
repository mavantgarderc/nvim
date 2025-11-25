local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptex",
    name = "PyTorch Examples Section",
    desc = "Inserts an Examples section in PyTorch style.",
  }, {
    t({ "", "Examples", "--------" }),
    t({ "", ">>> import torch" }),
    t({ "", ">>> " }),
    i(1, "tensor = torch.tensor([1, 2, 3])"),
    t({ "", "" }),
    i(2, "Expected output."),
  }),
}
