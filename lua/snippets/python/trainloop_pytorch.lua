local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "pttrain",
    name = "PyTorch Training Loop Docstring",
    desc = "Docstring for training loop functions.",
  }, {
    t({ '"""', "" }),
    i(1, "Trains the model for one epoch."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "model : nn.Module" }),
    t({ "", "    The model to train." }),
    t({ "", "dataloader : DataLoader" }),
    t({ "", "    DataLoader for training data." }),
    t({ "", "optimizer : Optimizer" }),
    t({ "", "    The optimizer." }),
    t({ "", "loss_fn : callable" }),
    t({ "", "    The loss function." }),
    t({ "", "device : torch.device" }),
    t({ "", "    Device to train on." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "float" }),
    t({ "", "    Average loss for the epoch." }),
    t({ "", '"""' }),
  }),
}
