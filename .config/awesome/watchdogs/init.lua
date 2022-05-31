local awful = require("awful")


local watchdogs = {}
watchdogs.signals = {}
watchdogs.scripts = {}
watchdogs.callbacks = {}

watchdogs.signals.prfx = 'watchdog::'
watchdogs.signals.ram = watchdogs.signals.prfx .. 'ram'

watchdogs.scripts[watchdogs.signals.ram] = 
[[
    bash -c "free -m | grep Mem: | awk '{printf \"#%d__%d#\", $2, $3}'"
]]


watchdogs.callbacks[watchdogs.signals.ram] = function(widget, stdout)
    local total = stdout:match('#(.*)__')
    local used  = stdout:match('__(.*)#')
    awesome.emit_signal("sysstat::ram", tonumber(used), tonumber(total))
end


watchdogs.run = function(watchdog, interval)
    awful.widget.watch(watchdogs.scripts[watchdog], interval, watchdogs.callbacks[watchdog])
end


watchdogs.init = function()
    watchdogs.run(watchdogs.signals.ram, 15)
end

return watchdogs