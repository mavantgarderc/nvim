local fn = vim.fn
local v = vim.v
local api = vim.api
local opt = vim.opt

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = "abcdefghijklmnopqrstuvwxyz",

    search = {
      multi_window = true,        -- search across all windows
      forward = true,             -- search forward by default
      wrap = true,                -- wrap search at end of buffer
      mode = "exact",             -- exact|search|fuzzy matching
      incremental = false,        -- show incremental search
      exclude = {                 -- exclude these filetypes
        "notify",
        "cmp_menu",
        "noice",
        "flash_prompt",
      },
      trigger = "",               -- trigger character for auto search
      max_length = false,         -- max pattern length
    },

    jump = {
      jumplist = true,            -- save location in jumplist
      pos = "start",              -- start|end|range - where to jump
      history = false,            -- remember previous jumps
      register = false,           -- save to register
      nohlsearch = false,         -- clear search highlights
      autojump = false,           -- auto jump if only one match
      inclusive = nil,            -- nil=auto, true=always inclusive
      offset = nil,               -- offset from match
    },

    label = {
      uppercase = true,           -- use uppercase labels
      exclude = "",               -- exclude these characters
      current = true,             -- include current position
      after = true,               -- show labels after match
      before = false,             -- show labels before match
      style = "overlay",          -- overlay|inline|eol
      reuse = "lowercase",        -- reuse labels: lowercase|all|none
      distance = true,            -- show distance from cursor
      min_pattern_length = 0,     -- min pattern length to show labels
      rainbow = {                 -- rainbow colors for labels
        enabled = false,
        shade = 1,
      },
    },

    highlight = {
      backdrop = true,            -- dim other text
      matches = true,             -- highlight all matches
      priority = 5000,            -- highlight priority
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },

    modes = {
      -- Regular search mode
      search = {
        enabled = false,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          mode = "search",
          max_length = 0,
          forward = true,
          wrap = true,
          multi_window = true,
        },
      },

      char = {
        enabled = true,
        config = function(opts)
          opts.autohide = opts.autohide == nil and (fn.mode(true):find("no") and v.operator == "y")
          opts.jump_labels = opts.jump_labels == nil and false
        end,
        autohide = false,
        jump_labels = false,
        multi_line = true,
        label = { exclude = "hjkliardc" },
        keys = { "T" },
        char_actions = function(motion)
          return {
            [";"] = "next",
            [","] = "prev",
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = { register = false },
      },

      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },

      treesitter_search = {
        jump = { pos = "range" },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = "inline" },
      },

      remote = {
        remote_op = { restore = true, motion = true },
      },
    },

    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        width = 1,
        height = 1,
        row = -1,
        col = 0,
        zindex = 1000,
      },
    },

    remote_op = {
      restore = false,            -- restore cursor position
      motion = false,             -- use motion for remote op
    },
  },

  config = function(_, opts)
    require("flash").setup(opts)

    -- Set up custom highlight groups
    -- api.nvim_set_hl(0, "FlashMatch", { bg = "#ff9900", fg = "#000000", bold = true })
    -- api.nvim_set_hl(0, "FlashCurrent", { bg = "#ff0000", fg = "#ffffff", bold = true })
    -- api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
    -- api.nvim_set_hl(0, "FlashLabel", { bg = "#ff007c", fg = "#ffffff", bold = true })
    -- api.nvim_set_hl(0, "FlashPromptIcon", { fg = "#ff9900" })

    -- Set up cursor autocmds
    api.nvim_create_autocmd("User", {
      pattern = "FlashPromptPre",
      callback = function()
        opt.guicursor = "n:block-FlashCursor"
      end,
    })

    api.nvim_create_autocmd("User", {
      pattern = "FlashPromptPost",
      callback = function()
        opt.guicursor = "n:block"
      end,
    })

    require("core.keymaps.flash")
  end,
}
