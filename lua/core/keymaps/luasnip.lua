local keymap = vim.keymap.set
local ls = require("luasnip")

-- LuaSnip keymaps
keymap({"i"}, "<C-K>", function() ls.expand() end, { silent = true, desc = "Expand snippet" })
keymap({"i", "s"}, "<C-L>", function() ls.jump( 1) end, { silent = true, desc = "Jump to next snippet node" })
keymap({"i", "s"}, "<C-J>", function() ls.jump(-1) end, { silent = true, desc = "Jump to previous snippet node" })

keymap({"i", "s"}, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = "Change snippet choice" })

-- Optional: Custom Python ML snippets
-- Create a file at ~/.config/nvim/snippets/python.lua
--[[
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  s("trainloop", {
    t({"for epoch in range(num_epochs):", "    model.train()", "    for batch_idx, (data, target) in enumerate(train_loader):", "        optimizer.zero_grad()", "        output = model(data)", "        loss = criterion(output, target)", "        loss.backward()", "        optimizer.step()", "        ", "        if batch_idx % log_interval == 0:", "            print(f'Train Epoch: {epoch} [{batch_idx * len(data)}/{len(train_loader.dataset)} ({100. * batch_idx / len(train_loader):.0f}%)]\\tLoss: {loss.item():.6f}')"}),
  }),

  s("mlflow", {
    t({"import mlflow", "import mlflow.pytorch", "", "with mlflow.start_run():", "    mlflow.log_param('epochs', "}), i(1, "num_epochs"), t({")", "    mlflow.log_param('lr', "}), i(2, "learning_rate"), t({")", "    ", "    # Training loop here", "    ", "    mlflow.log_metric('train_loss', "}), i(3, "loss.item()"), t({")", "    mlflow.pytorch.log_model(model, 'model')"}),
  }),

  s("wandb", {
    t({"import wandb", "", "wandb.init(project='"}), i(1, "project_name"), t({"')", "wandb.config.update({", "    'epochs': "}), i(2, "num_epochs"), t({",", "    'lr': "}), i(3, "learning_rate"), t({",", "})", "", "# Log metrics", "wandb.log({'loss': "}), i(4, "loss.item()"), t({"})"}),
  }),
}
--]]
