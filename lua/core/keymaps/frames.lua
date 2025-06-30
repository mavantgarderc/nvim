local map = vim.keymap.set
local api = vim.api
local bo = vim.bo
local env = vim.env
local opts = { noremap = true, silent = true, }

-- === === ===  ===  === === ===
-- === === ===  NVIM === === ===
-- === === ===  ===  === === ===

-- === === === Tabs === === ===
map("n", "<leader>on", ":on<CR>", opts) -- close all except the current
map("n", "<leader>gt", "gt", opts)
map("n", "<leader>gT", "gT", opts)

-- === === === Buffers === === ===
map("n", "<leader>bt", function() print("Filetype: " .. bo.filetype)                       end, opts)
map("n", "<leader>bb", function() print(api.nvim_buf_get_name(api.nvim_get_current_buf())) end, opts)
map("n", "<leader>bl", ":ls<CR>",        opts)
map("n", "<leader>bn", ":bnext<CR>",     opts)
map("n", "<leader>bp", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bd<CR>",        opts)

-- === === === Panes === === ===
map("n", "<leader>h", "<C-w>h", opts) -- Switch Window Left
map("n", "<leader>l", "<C-w>l", opts) -- Switch Window Right
map("n", "<leader>j", "<C-w>j", opts) -- Switch Window Down
map("n", "<leader>k", "<C-w>k", opts) -- Switch Window Up

map("n", "<leader>H", "<C-w>H", opts) -- Move Window to Left
map("n", "<leader>L", "<C-w>L", opts) -- Move Window to Right
map("n", "<leader>J", "<C-w>J", opts) -- Move Window to Down
map("n", "<leader>K", "<C-w>K", opts) -- Move Window to Up

map("n", "<leader>T", "<C-w>T", opts) -- move current pane to a new tab

--map("n", "<leader>r", "<C-w>r") -- rotate windows clockwise

map("n", "<leader>sph", ":sp<CR>", opts) -- split current window horizontally
map("n", "<leader>spv", ":vs<CR>", opts) -- split current window vertically

map("n", "<C-A-h>", ":vertical resize -1<CR>", opts )
map("n", "<C-A-l>", ":vertical resize +1<CR>", opts )
map("n", "<C-A-j>", ":resize -1<CR>",          opts )
map("n", "<C-A-k>", ":resize +1<CR>",          opts )
map("n", "<C-A-S-H>", ":vertical resize -5<CR>", opts )
map("n", "<C-A-S-L>", ":vertical resize +5<CR>", opts )
map("n", "<C-A-S-J>", ":resize -5<CR>",          opts )
map("n", "<C-A-S-K>", ":resize +5<CR>",          opts )


-- === === ===  ===  === === ===
-- === Terminal Multiplexer  ===
-- === === ===  ===  === === ===
local function setup_multiplexer_keymaps()
  local function detect_multiplexer()
    if env.TMUX then
      return "tmux"
    end
    if env.ZELLIJ then
      return "zellij"
    end
    local term = env.TERM or ""
    if term:match("screen") then
      return "screen"
    elseif term:match("tmux") then
      return "tmux"
    end

    return nil
  end

  local multiplexer = detect_multiplexer()
  if multiplexer then
    map("n", "<A-h>", ":NavigateLeft<CR>",  opts)
    map("n", "<A-j>", ":NavigateDown<CR>",  opts)
    map("n", "<A-k>", ":NavigateUp<CR>",    opts)
    map("n", "<A-l>", ":NavigateRight<CR>", opts)
  end
end
setup_multiplexer_keymaps()
