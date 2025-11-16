return {
  {
    "goolord/alpha-nvim",
    dependencies = { "echasnovski/mini.icons" },
    lazy = true,
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      alpha.setup(require("alpha.themes.startify").config)
      dashboard.section.header.val = {
        -- "                                                   ",
        -- "             ███        ██        ███           ██ ",
        -- "             ███       ███        ███           ███",
        -- "             ███       ███        ███           ███",
        -- " ███         ███       ███        ███           ███",
        -- "██████       ███       ███        ███  ██     █████",
        -- "████████     ███       ███        ███████    ██████",
        -- "███  █████   ███       ███        █████     ███ ███",
        -- "███    ███   ███       █████      ███       █   ███",
        -- "███    ███   ███     ████████     ███           ███",
        -- "███    ███   ███    ████  ████    ███           ███",
        -- "███    ███   ███     ████████     ███           ███",
        -- " ██    ███    ██       ████       ███           ██ ",
        "                                                                                             ",
        "                                                                                             ",
        "                                                                                             ",
        "           π≠≈π                                             =+++++π           π÷÷÷÷=π        ",
        "          ∞++++√                                            π++++≈π           π×+++≈π        ",
        "       π√++++++++√π          ∞π                             π++++π             ≠+++π         ",
        "    πππ++++×ππ×++++ππ        ×+-π                    π∞×π    ×+++              ∞+++π         ",
        "   π√-+++-π   ππ-+++×ππ      ÷+++-√π             πππ÷++×π    ÷+++       πππ    ∞+++π         ",
        " ππ-++++ππ      ππ-+++÷ππ    =++++++≈ππ        ππ√+++++×     =+++     ππ√++√ππ ∞+++π         ",
        "π×++++√π          ππ-+++÷π   ≠++++++++×ππ     π=++++÷++×π    =+++     π≠+++++≈π∞+++π         ",
        "π√+++++√π        ππ×+++-π    ≠+++π=++++++√ππ√×+++×ππ∞++×π    =+++     πππ÷+++++÷+++π         ",
        "  π∞+++++√π    ππ×++++ππ     ≠+++ πππ-+++++++++≠π   ∞++×π    =+++        πππ×++++++π         ",
        "   ππ≈+++++∞π π≠++++∞π       ≠+++    ππ≠+++++×ππ    ∞++-π    ÷+++           ππ∞-++++≈ππ      ",
        "      π∞+++++×++++∞π         ≠+++  ππ∞++++++++++πππ ∞+++π    ÷+++              ∞+++++++≈πππ  ",
        "       ππ≠++++++≈π           ≠+++ππ÷+++-√π π≈+++++=π≈+++π    ×+++π             ∞+++≈++++++=ππ",
        "       ππ≈+++++++≈ππ         ≠+++++++=π       π-++++++++π   π-+++π             ≈+++ππ√++++ππ ",
        "     ππ=++++×=+++++÷ππ       ≠+++++∞π          ππ∞++++++π   π++++π             =+++π  π√×π   ",
        "   ππ=+++++√πππ×+++++÷ππ     ≠++×ππ               ππ÷+++π   π++++√             =+++√         ",
        " ππ×+++++∞π    ππ++++++×ππ   ≠=π                    ππ√+π   π++++∞π            =+++√         ",
        " ≈+++++÷π        π√-++++-π   π                         ππ   √++++÷π           π×+++≈         ",
        "  π≠+-ππ           π√++ππ                                   ≠+++++π           π-+++÷π        ",
        "   πππ              πππ                                     ≠-++--π           π-+++÷π        ",
        "                                                                                             ",
        "                                                                                             ",
        "                                                                                             ",
      }

      local lazy_stats = require("lazy").stats()
      dashboard.section.footer.val = function()
        return {
          "Five hundred doors, and forty there are;",
          "I ween, in Valhall's walls;",
          "Eight hundred fighters; through one door fare;",
          "When to war with the wolf they go.",
          " ",
          "                                  - Odin, the Allfather",
          "                                  - The Lay of Grimnir",
          " ",
          "             Plugins loaded: " .. lazy_stats.loaded .. " / " .. lazy_stats.count,
          "           ",
        }
      end

      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  > Find file", ":cd $HOME/proj | Telescope find_files<CR>"),
        dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
        dashboard.button("q", "󰅚  > Quit NVIM", ":qa<CR>"),
      }

      dashboard.section.footer.opts = {
        position = "center",
        hl = "Comment",
      }

      alpha.setup(dashboard.opts)
      vim.cmd([[
             autocmd FileType alpha setlocal nofoldenable
             ]])
    end,
  },
}
