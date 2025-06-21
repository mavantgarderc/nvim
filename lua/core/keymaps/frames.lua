local map = vim.keymap.set
local api = vim.api
local bo = vim.bo

local opts = {
    noremap = true,
    silent = true,
}

-- === NVIM ===
-- Tabs
map("n", "<leader>on", ":on<CR>") -- close all except the current

-- Buffers
map("n", "<leader>bl", ":ls<CR>", opts)
map("n", "<leader>bt", function() print("Filetype: " .. bo.filetype) end, opts)
map("n", "<leader>bb", function() print(api.nvim_buf_get_name(api.nvim_get_current_buf())) end, opts)
map("n", "<leader>bn", ":bnext<CR>", opts)
map("n", "<leader>bp", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bd<CR>", opts)

-- Panes
map("n", "<leader>h", "<C-w>h", { desc = "Switch Window Left"  })
map("n", "<leader>l", "<C-w>l", { desc = "Switch Window Right" })
map("n", "<leader>j", "<C-w>j", { desc = "Switch Window Down"  })
map("n", "<leader>k", "<C-w>k", { desc = "Switch Window Up"    })

map("n", "<leader>H", "<C-w>H", { desc = "Move Window to Left"})
map("n", "<leader>L", "<C-w>L", { desc = "Move Window to Right"})
map("n", "<leader>J", "<C-w>J", { desc = "Move Window to Down"})
map("n", "<leader>K", "<C-w>K", { desc = "Move Window to Up"})

map("n", "<leader>T", "<C-w>T") -- move current pane to a new tab
map("n", "<leader>r", "<C-w>r") -- rotate windows clockwise

map("n", "<leader>sph<CR>", ":sp") -- split current window horizontally
map("n", "<leader>spv<CR>", ":vs") -- split current window vertically

-- Resize Panes
map("n", "<C-A-h>", ":vertical resize -1<CR>", opts )
map("n", "<C-A-l>", ":vertical resize +1<CR>", opts )
map("n", "<C-A-j>", ":resize -1<CR>",          opts )
map("n", "<C-A-k>", ":resize +1<CR>",          opts )

-- === Terminal Multiplexer ===
map("n", "<A-h>", ":ZellijNavigateLeftTab<CR>",  { silent = true })
map("n", "<A-j>", ":ZellijNavigateDown<CR>",     { silent = true })
map("n", "<A-k>", ":ZellijNavigateUp<CR>",       { silent = true })
map("n", "<A-l>", ":ZellijNavigateRightTab<CR>", { silent = true })
