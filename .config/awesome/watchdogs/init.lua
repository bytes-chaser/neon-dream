local awful = require("awful")


local watchdogs = {}
watchdogs.signals = {}
watchdogs.scripts = {}
watchdogs.callbacks = {}

watchdogs.signals.prfx = 'watchdog::'
watchdogs.signals.ram = watchdogs.signals.prfx .. 'ram'
watchdogs.signals.cpu = watchdogs.signals.prfx .. 'cpu'
watchdogs.signals.pow = watchdogs.signals.prfx .. 'pow'

watchdogs.scripts[watchdogs.signals.ram] =
[[
    bash -c "free -m | grep Mem: | awk '{printf \"#%d__%d#\", $2, $3}'"
]]

watchdogs.scripts[watchdogs.signals.cpu] =
[[
    bash -c "top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print 100-$8}'"
]]

watchdogs.scripts[watchdogs.signals.pow] =
[[
    bash -c "cat /sys/class/power_supply/BAT0/capacity"
]]


watchdogs.callbacks[watchdogs.signals.ram] = function(widget, stdout)
    local total = stdout:match('#(.*)__')
    local used  = stdout:match('__(.*)#')
    awesome.emit_signal("sysstat::ram", tonumber(used), tonumber(total))
end

watchdogs.callbacks[watchdogs.signals.cpu] = function(widget, stdout)
    awesome.emit_signal("sysstat::cpu", tonumber(stdout))
end

watchdogs.callbacks[watchdogs.signals.pow] = function(widget, stdout)
    awesome.emit_signal("sysstat::pow", tonumber(stdout))
end


watchdogs.run = function(watchdog, interval)
    awful.widget.watch(watchdogs.scripts[watchdog], interval, watchdogs.callbacks[watchdog])
end


watchdogs.init = function()
    watchdogs.run(watchdogs.signals.ram, 5)
    watchdogs.run(watchdogs.signals.cpu, 5)
    watchdogs.run(watchdogs.signals.pow, 5)
end

return watchdogs
