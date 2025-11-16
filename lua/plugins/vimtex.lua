local g = vim.g

return {
  "lervag/vimtex",
  lazy = true,
  ft = { "text", "bib" },
  init = function()
    g.tex_flavor = "latex"

    g.vimtex_view_method = "zathura"
    g.vimtex_view_forward_search_on_start = 1

    g.vimtex_compiler_method = "latexmk"
    g.vimtex_compiler_latexmk = {
      build_dir = "",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      hooks = {},
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
        -- "-shell-escape",  -- uncomment if you need packages like minted or external commands
      },
    }

    g.vimtex_syntax_enabled = 1
    g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      fancy = 1,
      spacing = 1,
      greek = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      sections = 1,
      styles = 1,
    }

    g.vimtex_complete_enabled = 0
    g.vimtex_complete_close_braces = 0

    g.vimtex_fold_enabled = 1
    g.vimtex_fold_manual = 0

    g.vimtex_quickfix_mode = 0
    g.vimtex_quickfix_open_on_warning = 0

    g.vimtex_indent_enabled = 1
    g.vimtex_matchparen_enabled = 1
    g.vimtex_imaps_enabled = 1
  end,
}
