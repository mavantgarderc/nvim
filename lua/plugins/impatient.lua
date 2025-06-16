return {
    "lewis6991/impatient.nvim",
    priority = 1000,
    config = function()
        vim.g.impatient_enable_profile = 1
        vim.g.impatient_cache_size = 100
        vim.g.impatient_cache_persist = 1
        require("impatient")
        -- Add command to show stats
        vim.api.nvim_create_user_command("ShowStartupStats", function()
            local ok, stats = pcall(function() return require("impatient").get_stats() end)

            if ok and stats then
                local msg =
                    string.format("Startup time: %.3fms (%.1fx faster)", stats.startup_time * 1000, stats.speed_ratio)
                vim.notify(msg, vim.log.levels.INFO, { title = "impatient.nvim" })
            else
                vim.notify("Startup statistics not available", vim.log.levels.WARN)
            end
        end, {})
    end,
}
