local awful = require("awful")
local commands = require("commons.commands")
local naughty = require("naughty")

local watchdogs = {}
watchdogs.signals = {}
watchdogs.scripts = {}
watchdogs.callbacks = {}

watchdogs.signals.prfx = 'watchdog::'
watchdogs.signals.ram = watchdogs.signals.prfx .. 'ram'
watchdogs.signals.cpu = watchdogs.signals.prfx .. 'cpu'
watchdogs.signals.pow = watchdogs.signals.prfx .. 'pow'
watchdogs.signals.ps = watchdogs.signals.prfx .. 'ps'

watchdogs.scripts[watchdogs.signals.ram] = commands.ram
watchdogs.scripts[watchdogs.signals.cpu] = commands.cpu
watchdogs.scripts[watchdogs.signals.pow] = commands.pow
watchdogs.scripts[watchdogs.signals.ps] = commands.top_ps

watchdogs.callbacks[watchdogs.signals.ram] = function(widget, stdout)
    local total = stdout:match('#(.*)__')
    local used  = stdout:match('__(.*)#')
    awesome.emit_signal("sysstat::ram", tonumber(used), tonumber(total))
end

watchdogs.callbacks[watchdogs.signals.cpu] = function(widget, stdout)
    awesome.emit_signal("sysstat::cpu", tonumber(stdout))
end

watchdogs.callbacks[watchdogs.signals.pow] = function(widget, stdout)
  local status = stdout:match('(.*) ')
  local capacity  = stdout:match(' (.*)')
  awesome.emit_signal("sysstat::pow", tonumber(capacity), status)
end

watchdogs.callbacks[watchdogs.signals.ps] = function(widget, stdout)

  local lines_tbl = {}
  local i = 1
  local j = 1
  for line in stdout:gmatch("[^\r\n]+") do
    lines_tbl[i] = {}
    for cell in stdout:gmatch("(.+)%s+") do
      naughty.notify({text = tostring(cell) })
      lines_tbl[i][j] = cell
      j = j + 1
    end
    i = i + 1
  end

  awesome.emit_signal("sysstat::ps", lines_tbl)
end


watchdogs.run = function(watchdog, interval)
    awful.widget.watch(watchdogs.scripts[watchdog], interval, watchdogs.callbacks[watchdog])
end


watchdogs.init = function()
    watchdogs.run(watchdogs.signals.ram, 5)
    watchdogs.run(watchdogs.signals.cpu, 5)
    watchdogs.run(watchdogs.signals.pow, 2)
  --   watchdogs.run(watchdogs.signals.ps, 2)
end

return watchdogs
