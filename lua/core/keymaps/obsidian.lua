local M = {}

function M.set_keymaps(bufnr)
    local map = vim.keymap.set
    local wk = require("which-key")

    map("n", "<leader>oo", ":ObsidianOpen<CR>",          { desc = "Open vault", buffer = bufnr })
    map("n", "<leader>on", ":ObsidianNew<CR>",           { desc = "New note", buffer = bufnr })
    map("n", "<leader>oq", ":ObsidianQuickSwitch<CR>",   { desc = "Quick switch", buffer = bufnr })
    map("n", "<leader>ot", ":ObsidianToday<CR>",         { desc = "Today’s note", buffer = bufnr })
    map("n", "<leader>oy", ":ObsidianYesterday<CR>",     { desc = "Yesterday’s note", buffer = bufnr })
    map("n", "<leader>ob", ":ObsidianBacklinks<CR>",     { desc = "Backlinks", buffer = bufnr })
    map("n", "<leader>os", ":ObsidianSearch<CR>",        { desc = "Search notes", buffer = bufnr })
    map("n", "<leader>of", ":ObsidianFollowLink<CR>",    { desc = "Follow link", buffer = bufnr })
    map("n", "<leader>od", ":ObsidianDailies<CR>",       { desc = "List dailies", buffer = bufnr })
    map("n", "<leader>ol", ":ObsidianLink<CR>",          { desc = "Link to note", buffer = bufnr })
    map("v", "<leader>ol", ":ObsidianLinkNew<CR>",       { desc = "Link visual selection", buffer = bufnr })
    map("n", "<leader>or", ":ObsidianRename<CR>",        { desc = "Rename note", buffer = bufnr })
    map("n", "<leader>om", ":ObsidianTemplate<CR>",      { desc = "Insert template", buffer = bufnr })
    map("n", "<leader>oi", ":ObsidianPasteImg<CR>",      { desc = "Paste image", buffer = bufnr })
    map("n", "<leader>oc", ":ObsidianCheck<CR>",         { desc = "Check note", buffer = bufnr })

    if wk then
        wk.register({
            o = {
                name = "Obsidian",
                o = "Open vault",
                n = "New note",
                q = "Quick switch",
                t = "Today",
                y = "Yesterday",
                b = "Backlinks",
                s = "Search",
                f = "Follow link",
                d = "List dailies",
                l = "Link note",
                r = "Rename note",
                m = "Insert template",
                i = "Paste image",
                c = "Check note",
            },
        }, { prefix = "<leader>", buffer = bufnr })
    end
end

return M
