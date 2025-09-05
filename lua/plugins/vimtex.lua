local g = vim.g

return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    g.vimtex_view_method = "zathura" -- yay -S zathura

    -- Compiler
    g.vimtex_compiler_method = "latexmk"

    -- Misc
    g.vimtex_quickfix_mode = 0   -- don't auto-open quickfix on errors
    g.vimtex_complete_enabled = 1
    g.vimtex_fold_enabled = 1
  end,
}
