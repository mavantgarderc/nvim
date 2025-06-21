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
map("n", "<leader>h", "<C-w>h", { desc = "switch window left"  })
map("n", "<leader>l", "<C-w>l", { desc = "switch window right" })
map("n", "<leader>j", "<C-w>j", { desc = "switch window down"  })
map("n", "<leader>k", "<C-w>k", { desc = "switch window up"    })

map("n", "<leader>H", "C-w>H")
map("n", "<leader>L", "C-w>L")
map("n", "<leader>J", "C-w>J")
map("n", "<leader>K", "C-w>K")
-- Resize Panes
map("n", "<C-A-h>", ":vertical resize -1<CR>", opts )
map("n", "<C-A-l>", ":vertical resize +1<CR>", opts )
map("n", "<C-A-j>", ":resize -1<CR>",          opts )
map("n", "<C-A-k>", ":resize +1<CR>",          opts )

-- === Terminal Multiplexer ===
map("n", "<A-h>", ":ZellijNavigateLeftTab<CR>",  { silent = true, desc = "Navigate Left"  })
map("n", "<A-j>", ":ZellijNavigateDown<CR>",     { silent = true, desc = "Navigate Down"  })
map("n", "<A-k>", ":ZellijNavigateUp<CR>",       { silent = true, desc = "Navigate Up"    })
map("n", "<A-l>", ":ZellijNavigateRightTab<CR>", { silent = true, desc = "Navigate Right" })
