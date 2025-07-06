local cmd = vim.cmd
local fn = vim.fn
local api = vim.api
local map = vim.keymap.set
local o = vim.o

map("n", "<leader>u", cmd.UndotreeToggle, { desc = "Toggle undotree" })

map("n", "<leader>ut", cmd.UndotreeToggle, { desc = "Toggle undotree" })
map("n", "<leader>uf", cmd.UndotreeFocus, { desc = "Focus undotree window" })
map("n", "<leader>us", cmd.UndotreeShow, { desc = "Show undotree" })
map("n", "<leader>uh", cmd.UndotreeHide, { desc = "Hide undotree" })

map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })

map("v", "<C-z>", "<Esc>u", { desc = "Undo" })
map("v", "<C-y>", "<Esc><C-r>", { desc = "Redo" })

map("i", ",", ",<C-g>u", { desc = "Undo breakpoint" })
map("i", ".", ".<C-g>u", { desc = "Undo breakpoint" })
map("i", "!", "!<C-g>u", { desc = "Undo breakpoint" })
map("i", "?", "?<C-g>u", { desc = "Undo breakpoint" })
map("i", ";", ";<C-g>u", { desc = "Undo breakpoint" })
map("i", ":", ":<C-g>u", { desc = "Undo breakpoint" })

local function create_undo_checkpoint()
    cmd("normal! i<C-g>u<Esc>")
    print("Undo checkpoint created")
end

map("n", "<leader>uc", create_undo_checkpoint, { desc = "Create undo checkpoint" })

local function setup_undotree_buffer_keymaps()
    local bufnr = api.nvim_get_current_buf()
    local buf_name = api.nvim_buf_get_name(bufnr)

    if string.match(buf_name, "undotree") then
        -- Navigation within undotree
        map("n", "j", "j", { buffer = bufnr, desc = "Move down in undotree" })
        map("n", "k", "k", { buffer = bufnr, desc = "Move up in undotree" })
        map("n", "J", "5j", { buffer = bufnr, desc = "Move down 5 lines in undotree" })
        map("n", "K", "5k", { buffer = bufnr, desc = "Move up 5 lines in undotree" })
        map("n", "<CR>", "<CR>", { buffer = bufnr, desc = "Select undo state" })
        map("n", "q", ":UndotreeHide<CR>", { buffer = bufnr, desc = "Close undotree" })
        map("n", "<Esc>", ":UndotreeHide<CR>", { buffer = bufnr, desc = "Close undotree" })

        map("n", "p", "p", { buffer = bufnr, desc = "Go to previous state" })
        map("n", "n", "n", { buffer = bufnr, desc = "Go to next state" })

        map("n", "d", "d", { buffer = bufnr, desc = "Toggle diff panel" })

        map("n", "?", "?", { buffer = bufnr, desc = "Show help" })
    end
end

-- Auto-command to set up buffer-specific keymaps for undotree
api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = setup_undotree_buffer_keymaps,
    desc = "Setup undotree buffer keymaps",
})

-- Function to show undo tree statistics
local function show_undo_stats()
    local stats = {
        undolevels = o.undolevels,
        undoreload = o.undoreload,
        undofile   = o.undofile,
        undodir    = o.undodir,
    }

    print("Undo Configuration:")
    print("  Undo levels: " .. stats.undolevels)
    print("  Undo reload: " .. stats.undoreload)
    print("  Undo file: " .. tostring(stats.undofile))
    print("  Undo dir: " .. stats.undodir)

    if fn.has("persistent_undo") == 1 then
        print("  Persistent undo: enabled")
    else
        print("  Persistent undo: disabled")
    end
end

map("n", "<leader>ui", show_undo_stats, { desc = "Show undo info/stats" })
