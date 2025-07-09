local map = vim.map.set
local opts = { noremap = true, silent = true }
local cmd = vim.cmd
local fn = vim.fn

map("n", "<leader>tn", ":tabnew<CR>", opts)                    -- New tab
map("n", "<leader>tc", ":tabclose<CR>", opts)                  -- Close current tab
map("n", "<leader>to", ":tabonly<CR>", opts)                   -- Close all other tabs
map("n", "<leader>tt", ":tabnext<CR>", opts)                   -- Next tab
map("n", "<leader>tp", ":tabprevious<CR>", opts)               -- Previous tab

map("n", "gt", ":tabnext<CR>", opts)                           -- Next tab
map("n", "gT", ":tabprevious<CR>", opts)                       -- Previous tab
map("n", "g1", "1gt", opts)                                    -- Go to tab 1
map("n", "g2", "2gt", opts)                                    -- Go to tab 2
map("n", "g3", "3gt", opts)                                    -- Go to tab 3
map("n", "g4", "4gt", opts)                                    -- Go to tab 4
map("n", "g5", "5gt", opts)                                    -- Go to tab 5
map("n", "g6", "6gt", opts)                                    -- Go to tab 6
map("n", "g7", "7gt", opts)                                    -- Go to tab 7
map("n", "g8", "8gt", opts)                                    -- Go to tab 8
map("n", "g9", "9gt", opts)                                    -- Go to tab 9
map("n", "g0", ":tablast<CR>", opts)                           -- Go to last tab

map("n", "<leader>tm", ":tabmove<CR>", opts)                   -- Move tab (will prompt for position)
map("n", "<leader>t<", ":tabmove -1<CR>", opts)               -- Move tab left
map("n", "<leader>t>", ":tabmove +1<CR>", opts)               -- Move tab right

map("n", "<C-t>", ":tabnew<CR>", opts)                        -- Quick new tab
map("n", "<C-w>t", ":tabnew<CR>", opts)                       -- Alternative new tab

map("n", "<leader>te", ":tabedit ", { noremap = true })        -- Edit file in new tab (no silent to see command)
map("n", "<leader>tf", ":tabfind ", { noremap = true })        -- Find and open file in new tab

map("n", "<leader>ts", "<C-w>T", opts)                        -- Move current split to new tab

map("n", "<leader>tT", ":tabnew | terminal<CR>", opts)         -- Open terminal in new tab

local function create_tab_with_file(filename)
    cmd("tabnew " .. filename)
end

local function close_other_tabs()
    cmd("tabonly")
end

local function close_tabs_right()
    local current_tab = fn.tabpagenr()
    local last_tab = fn.tabpagenr("$")

    for i = last_tab, current_tab + 1, -1 do
        cmd(i .. "tabclose")
    end
end

local function close_tabs_left()
    local current_tab = fn.tabpagenr()
    for i = current_tab - 1, 1, -1 do
        cmd("1tabclose")
    end
end

map("n", "<leader>tO", close_other_tabs, opts)                 -- Close all other tabs (function)
map("n", "<leader>tR", close_tabs_right, opts)                 -- Close tabs to the right
map("n", "<leader>tL", close_tabs_left, opts)                  -- Close tabs to the left

map("n", "<leader>ti", ":tabs<CR>", opts)                      -- List all tabs

map("n", "<leader>tb", ":tab split<CR>", opts)                 -- Open current buffer in new tab
map("n", "<leader>td", ":tab drop ", { noremap = true })       -- Drop file in tab (no silent to see command)

map("n", "<leader>th", "1gt", opts)                            -- Go to first tab (home)
map("n", "<leader>tl", ":tablast<CR>", opts)                   -- Go to last tab
