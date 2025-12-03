local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "pteval",
		name = "PyTorch Evaluation Function Docstring",
		desc = "Docstring for model evaluation functions.",
	}, {
		t({ '"""', "" }),
		i(1, "Evaluates the model on the validation set."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "model : nn.Module" }),
		t({ "", "    The model to evaluate." }),
		t({ "", "dataloader : DataLoader" }),
		t({ "", "    DataLoader for validation data." }),
		t({ "", "loss_fn : callable" }),
		t({ "", "    The loss function." }),
		t({ "", "device : torch.device" }),
		t({ "", "    Device to evaluate on." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "float" }),
		t({ "", "    Average loss or metric." }),
		t({ "", '"""' }),
	}),
}
