local opts = { noremap = true, silent = true, buffer = true }

local group = vim.api.nvim_create_augroup("vimtex_keymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "tex",
  callback = function(ev)
    local buf = ev.buf
    local map = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = buf })
    end

    -- Compile commands
    map("n", "<leader>lc", ":VimtexCompile<CR>")         -- Full compile
    map("n", "<leader>ll", ":VimtexCompileSelected<CR>") -- Compile selection
    map("n", "<leader>lk", ":VimtexStop<CR>")            -- Stop current compile
    map("n", "<leader>lK", ":VimtexStopAll<CR>")         -- Stop all compiles

    -- View and sync
    map("n", "<leader>lv", ":VimtexView<CR>")          -- View PDF (forward search)
    map("n", "<leader>lr", ":VimtexReverseSearch<CR>") -- Inverse search (from PDF to source)

    -- Clean up
    map("n", "<leader>lC", ":VimtexClean<CR>") -- Clean aux files

    -- TOC and navigation
    map("n", "<leader>lt", ":VimtexTocToggle<CR>")    -- Toggle table of contents
    map("n", "<leader>lT", ":VimtexLabelsToggle<CR>") -- Toggle labels list (useful for refs)

    -- Status and errors
    map("n", "<leader>ls", ":VimtexStatus<CR>") -- Compilation status
    map("n", "<leader>le", ":VimtexErrors<CR>") -- Open quickfix with errors
    map("n", "<leader>li", ":VimtexInfo<CR>")   -- Vimtex info

    -- Text objects (optional, for easier selection)
    map("o", "ie", "<plug>(vimtex-ie)") -- Inner environment
    map("o", "ae", "<plug>(vimtex-ae)") -- Outer environment
    map("x", "ie", "<plug>(vimtex-ie)") -- Visual inner env
    map("x", "ae", "<plug>(vimtex-ae)") -- Visual outer env

    -- Insert mode mappings (examples for common LaTeX shortcuts)
    map("i", "[[", "\\begin{}<Left>")
    map("i", "]]", "\\end{}<Left>")
  end,
})
