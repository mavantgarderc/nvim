-- lua/core/keymaps/obsidian.lua
local M = {}

function M.set_keymaps(bufnr)
  local map = vim.keymap.set
  local wk = require("which-key")

  map("n", "<leader>obo", ":ObsidianOpen<CR>", { desc = "Open vault", buffer = bufnr })
  map("n", "<leader>obn", ":ObsidianNew<CR>", { desc = "New note", buffer = bufnr })
  map("n", "<leader>obq", ":ObsidianQuickSwitch<CR>", { desc = "Quick switch", buffer = bufnr })
  map("n", "<leader>obt", ":ObsidianToday<CR>", { desc = "Today's note", buffer = bufnr })
  map("n", "<leader>oby", ":ObsidianYesterday<CR>", { desc = "Yesterday's note", buffer = bufnr })
  map("n", "<leader>obb", ":ObsidianBacklinks<CR>", { desc = "Backlinks", buffer = bufnr })
  map("n", "<leader>obs", ":ObsidianSearch<CR>", { desc = "Search notes", buffer = bufnr })
  map("n", "<leader>obf", ":ObsidianFollowLink<CR>", { desc = "Follow link", buffer = bufnr })
  map("n", "<leader>obd", ":ObsidianDailies<CR>", { desc = "List dailies", buffer = bufnr })
  map("n", "<leader>obl", ":ObsidianLink<CR>", { desc = "Link to note", buffer = bufnr })
  map("v", "<leader>obl", ":ObsidianLinkNew<CR>", { desc = "Link visual selection", buffer = bufnr })
  map("n", "<leader>obr", ":ObsidianRename<CR>", { desc = "Rename note", buffer = bufnr })
  map("n", "<leader>obm", ":ObsidianTemplate<CR>", { desc = "Insert template", buffer = bufnr })
  map("n", "<leader>obi", ":ObsidianPasteImg<CR>", { desc = "Paste image", buffer = bufnr })
  map("n", "<leader>obc", ":ObsidianCheck<CR>", { desc = "Check note", buffer = bufnr })

  if wk then
    wk.add({
      { "<leader>ob",  buffer = bufnr, group = "Obsidian" },
      { "<leader>obo", buffer = bufnr, desc = "Open vault" },
      { "<leader>obn", buffer = bufnr, desc = "New note" },
      { "<leader>obq", buffer = bufnr, desc = "Quick switch" },
      { "<leader>obt", buffer = bufnr, desc = "Today's note" },
      { "<leader>oby", buffer = bufnr, desc = "Yesterday's note" },
      { "<leader>obb", buffer = bufnr, desc = "Backlinks" },
      { "<leader>obs", buffer = bufnr, desc = "Search notes" },
      { "<leader>obf", buffer = bufnr, desc = "Follow link" },
      { "<leader>obd", buffer = bufnr, desc = "List dailies" },
      { "<leader>obl", buffer = bufnr, desc = "Link to note",    mode = { "n", "v" } },
      { "<leader>obr", buffer = bufnr, desc = "Rename note" },
      { "<leader>obm", buffer = bufnr, desc = "Insert template" },
      { "<leader>obi", buffer = bufnr, desc = "Paste image" },
      { "<leader>obc", buffer = bufnr, desc = "Check note" },
    })
  end
end

return M
