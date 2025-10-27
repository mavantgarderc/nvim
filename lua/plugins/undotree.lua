return {
  "mbbill/undotree",
  config = function()
    local g = vim.g
    local fn = vim.fn
    local opt = vim.opt

    g.undotree_WindowLayout = 2
    g.undotree_SplitWidth = 40
    g.undotree_DiffpanelHeight = 15
    g.undotree_SetFocusWhenToggle = 1
    g.undotree_ShortIndicators = 1
    g.undotree_HighlightChangedText = 1
    g.undotree_HighlightChangedWithSign = 1
    g.undotree_HighlightSyntaxAdd = "DiffAdd"
    g.undotree_HighlightSyntaxChange = "DiffChange"
    g.undotree_HighlightSyntaxDel = "DiffDelete"

    g.undotree_DiffAutoOpen = 1
    g.undotree_DiffCommand = "diff"

    g.undotree_TreeNodeShape = "*"
    g.undotree_TreeVertShape = "|"
    g.undotree_TreeSplitShape = "/"
    g.undotree_TreeReturnShape = "\\"

    g.undotree_RelativeTimestamp = 1

    if fn.has("persistent_undo") == 1 then
      local undodir = fn.expand("~/undodir")
      if fn.isdirectory(undodir) == 0 then
        fn.mkdir(undodir, "p")
      end
      opt.undodir = undodir
      opt.undofile = true
    end

    opt.undolevels = 10000
    opt.undoreload = 10000

    require("core.keymaps.undotree")
  end,
}
