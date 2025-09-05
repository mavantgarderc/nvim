local vim = vim
local api = vim.api
local opts = { noremap = true, silent = true, buffer = true }

local group = api.nvim_create_augroup("vimtex_keymaps", { clear = true })

api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "tex",
  callback = function(ev)
    local buf = ev.buf
    local map = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = buf })
    end

    -- Compile
    map("n", "<leader>lc", ":VimtexCompile<CR>")
    map("n", "<leader>ll", ":VimtexCompileSelected<CR>")
    map("n", "<leader>lk", ":VimtexStop<CR>")
    map("n", "<leader>lK", ":VimtexStopAll<CR>")

    -- View
    map("n", "<leader>lv", ":VimtexView<CR>")

    -- Clean
    map("n", "<leader>lC", ":VimtexClean<CR>")

    -- TOC
    map("n", "<leader>lt", ":VimtexTocToggle<CR>")

    -- Status
    map("n", "<leader>ls", ":VimtexStatus<CR>")
  end,
})
