local map = vim.keymap.set

-- normalize pasting
map("x", "<leader>p", '"_dp')

-- replace the cursor under word, in entire buffer
map("n", "<leader>s", ":%s/\\<<C-r><C-w>>\\>//gI<Left><Left>")

-- add execution permission
map("n", "<leader>x", ":!chmod +x %<CR>", { silent = true })

-- source current file
map("n", "<leader>o", ":so %<CR>", { silent = true })
