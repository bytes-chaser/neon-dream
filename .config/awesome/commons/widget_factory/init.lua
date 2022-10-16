local awful = require('awful')

local widget_registry = {}

local function has_no_value (val)
    for _, value in ipairs(widget_registry) do
        if value == val then
            return false
        end
    end
    return true
end

createWidget = function(module, params)

    local signal = module.name;

    if has_no_value(signal) then
        local watchdogs = module.watchdogs;

        for _, watchdog in ipairs(watchdogs) do
            local command  = watchdog.command
            local interval = watchdog.interval
            local callback = watchdog.callback

            awful.widget.watch(command, interval, callback)
        end

        table.insert(widget_registry, signal)
    end

    return module.create(params);
end