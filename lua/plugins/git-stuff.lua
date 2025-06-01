return {
    -- LazyGit integration
    {
        "kdheepak/lazygit.nvim",
        cmd = { "LazyGit" },
        keys = {
            vim.keymap.set("n", "<leader>lg", function()
                vim.cmd("LazyGit")
            end),
            { "<leader>lg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
        },
    },

    -- Fugitive
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", vim.cmd.Git, desc = "Git status (Fugitive)" },
        },
    },

    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local gitsigns = require("gitsigns")

            gitsigns.setup()

            local cmd = vim.cmd
            local wo = vim.wo
            local fn = vim.fn
            local function map(mode, l, r, opts)
                opts = opts or {}
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                if wo.diff then
                    cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, { desc = "Next hunk" })

            map("n", "[c", function()
                if wo.diff then
                    cmd.normal({ "[c", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, { desc = "Prev hunk" })

            -- Actions

            map("n", "<leader>tb", gitsigns.toggle_current_line_blame)

            map("v", "<leader>hs", function()
                gitsigns.stage_hunk({ fn.line("."), fn.line("v") })
            end, { desc = "Stage hunk (visual)" })

            map("v", "<leader>hr", function()
                gitsigns.reset_hunk({ fn.line("."), fn.line("v") })
            end, { desc = "Reset hunk (visual)" })


            map("n", "<leader>hi", gitsigns.preview_hunk_inline)

            map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
            end, { desc = "Blame line (full)" })

            -- map("n", "<leader>hs", gitsigns.stage_hunk)
            -- map("n", "<leader>hr", gitsigns.reset_hunk)
            -- map("n", "<leader>hS", gitsigns.stage_buffer)
            -- map("n", "<leader>hR", gitsigns.reset_buffer)
            --map("n", "<leader>ph", gitsigns.preview_hunk, { desc = "Preview hunk" })
            -- map("n", "<leader>hd", gitsigns.diffthis)
            -- map("n", "<leader>hD", function()
            --     gitsigns.diffthis("~")
            -- end)
            -- map("n", "<leader>hQ", function() gitsigns.setqflist("all") end)
            -- map("n", "<leader>hq", gitsigns.setqflist)
            -- -- Toggles
            -- map("n", "<leader>tw", gitsigns.toggle_word_diff)
        end,
    },
}
