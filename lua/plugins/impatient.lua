return {
    "lewis6991/impatient.nvim",
    priority = 1000,
    config = function()
        local g = vim.g
        local fn = vim.fn
        local api = vim.api
        local log = vim.log
        local notify = vim.notify
        local bo = vim.bo

        g.impatient = {
            enable_profile = 1,
            cache_size = 1000,
            cache_persist = 1,
            cache_path = fn.stdpath("cache") .. "/impatient",
            debug = 0,
        }

        local status_ok, impatient = pcall(require, "impatient")
        if not status_ok then
            notify("impatient.nvim failed to load", log.levels.ERROR)
            return
        end

        api.nvim_create_user_command("ShowStartupStats", function()
            local stats = impatient.get_stats()
            if not stats then
                notify("Startup statistics not available", log.levels.WARN)
                return
            end

            local msg = string.format(
                "Startup time: %.3fms (%.1fx faster)\nCached modules: %d",
                stats.startup_time * 1000,
                stats.speed_ratio,
                stats.cached_modules
            )

            notify(msg, log.levels.INFO, {
                title = "impatient.nvim",
                timeout = 5000,
            })
        end, {})

        api.nvim_create_user_command("ShowModuleStats", function()
            local stats = impatient.get_stats()
            if not stats then
                notify("Module statistics not available", log.levels.WARN)
                return
            end

            local buf = api.nvim_create_buf(false, true)
            api.nvim_buf_set_name(buf, "impatient-stats")

            local lines = {
                "IMPATIENT.NVIM MODULE STATISTICS",
                "=================================",
                string.format("Total startup time: %.3fms", stats.startup_time * 1000),
                string.format("Speed ratio: %.1fx faster", stats.speed_ratio),
                "---------------------------------",
                "Module Name" .. string.rep(" ", 45) .. "Load Time (ms)",
            }

            local sorted_modules = {}
            for name, time in pairs(stats.modules) do
                table.insert(sorted_modules, { name = name, time = time })
            end

            table.sort(sorted_modules, function(a, b) return a.time > b.time end)

            for _, mod in ipairs(sorted_modules) do
                local formatted_time = string.format("%.3f", mod.time * 1000)
                local padding = string.rep(" ", 55 - #mod.name)
                table.insert(lines, mod.name .. padding .. formatted_time)
            end

            api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            api.nvim_command("vsplit | buffer " .. buf)
            bo[buf].modifiable = false
            bo[buf].filetype = "impatient-stats"
        end, {})
    end,
}
