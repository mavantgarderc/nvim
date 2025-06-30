return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    autopairs.setup({
      check_ts = true,
      enable_check_bracket_line = false,
      ignored_next_char = "[%w%.]",
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        offset = -1,
      },
    })

    autopairs.add_rules({
      Rule("'", "'", { "-python", "-lua" })
        :with_pair(cond.not_after_regex("%w"))
        :with_pair(cond.not_before_regex("%w")),

      Rule(" ", " ")
        :with_pair(function(opts)
          return vim.tbl_contains({ "(", "[", "{", "<" }, opts.prev_char:sub(-1, -1))
        end),

      Rule("$", "$", "tex")
        :with_move(cond.after_text("$"))
    })

    autopairs.add_rules({
      Rule("<!--", "-->", "html"):only_cr(),
      Rule("<", ">", { "html", "typescriptreact", "javascriptreact" })
        :replace_endpair(function(opts)
          return string.format("</%s>", opts.ts_match or "")
        end)
        :use_regex(true)
        :set_end_pair_length(0),
    })

    -- ===== CMP Integration =====
    local cmp_ok, cmp = pcall(require, "cmp")
    if cmp_ok then
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end
  end
}
