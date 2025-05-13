return {
  "goolord/alpha-nvim",
  lazy = false,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    -- Set header
    dashboard.section.header.val = {
"               π≠≈π                                              =+++++π           π÷÷÷÷=π          ",
"              ∞++++√                                             π++++≈π           π×+++≈π          ",
"           π√++++++++√π          ∞π                              π++++π             ≠+++π           ",
"        πππ++++×ππ×++++ππ        ×+-π                    π∞×π     ×+++              ∞+++π           ",
"       π√-+++-π   ππ-+++×ππ      ÷+++-√π             πππ÷++×π     ÷+++       πππ    ∞+++π           ",
"     ππ-++++ππ      ππ-+++÷ππ    =++++++≈ππ        ππ√+++++×      =+++     ππ√++√ππ ∞+++π           ",
"    π×++++√π          ππ-+++÷π   ≠++++++++×ππ     π=++++÷++×π     =+++     π≠+++++≈π∞+++π           ",
"    π√+++++√π        ππ×+++-π    ≠+++π=++++++√ππ√×+++×ππ∞++×π     =+++     πππ÷+++++÷+++π           ",
"      π∞+++++√π    ππ×++++ππ     ≠+++ πππ-+++++++++≠π   ∞++×π     =+++        πππ×++++++π           ",
"       ππ≈+++++∞π π≠++++∞π       ≠+++    ππ≠+++++×ππ    ∞++-π     ÷+++           ππ∞-++++≈ππ        ",
"          π∞+++++×++++∞π         ≠+++  ππ∞++++++++++πππ ∞+++π     ÷+++              ∞+++++++≈πππ    ",
"           ππ≠++++++≈π           ≠+++ππ÷+++-√π π≈+++++=π≈+++π     ×+++π             ∞+++≈++++++=ππ  ",
"           ππ≈+++++++≈ππ         ≠+++++++=π       π-++++++++π    π-+++π             ≈+++ππ√++++ππ   ",
"         ππ=++++×=+++++÷ππ       ≠+++++∞π          ππ∞++++++π    π++++π             =+++π  π√×π     ",
"       ππ=+++++√πππ×+++++÷ππ     ≠++×ππ               ππ÷+++π    π++++√             =+++√           ",
"     ππ×+++++∞π    ππ++++++×ππ   ≠=π                    ππ√+π    π++++∞π            =+++√           ",
"     ≈+++++÷π        π√-++++-π   π                         ππ    √++++÷π           π×+++≈           ",
"      π≠+-ππ           π√++ππ                                    ≠+++++π           π-+++÷π          ",
"       πππ              πππ                                      ≠-++--π           π-+++÷π          ",
    }

    -- Set footer
    local lazy_stats = require("lazy").stats() -- Get Lazy.nvim stats
    dashboard.section.footer.val = {
        "Five hundred doors, and forty there are;",
        "I ween, in Valhall's walls;",
        "Eight hundred fighters; through one door fare;",
        "When to war with the wolf they go.",
      " ",
      "                                  - Odin, the Allfather",
      "                                  - The Lay of Grimnir",
      " ",
      "             Plugins loaded: " .. lazy_stats.loaded .. " / " .. lazy_stats.count,
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[
      autocmd FileType alpha setlocal nofoldenable
    ]])
  end,
}
