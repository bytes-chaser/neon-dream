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
watchdogs.signals.temp = watchdogs.signals.prfx .. 'temp'
watchdogs.signals.ps = watchdogs.signals.prfx .. 'ps'
watchdogs.signals.diskroot = watchdogs.signals.prfx .. 'diskroot'
watchdogs.signals.diskboot = watchdogs.signals.prfx .. 'diskboot'
watchdogs.signals.diskhome = watchdogs.signals.prfx .. 'diskhome'

watchdogs.scripts[watchdogs.signals.ram] = commands.ram
watchdogs.scripts[watchdogs.signals.cpu] = commands.cpu
watchdogs.scripts[watchdogs.signals.pow] = commands.pow
watchdogs.scripts[watchdogs.signals.temp] = commands.temp
watchdogs.scripts[watchdogs.signals.ps] = commands.top_ps
watchdogs.scripts[watchdogs.signals.diskroot] = commands.get_disk_root_info
watchdogs.scripts[watchdogs.signals.diskboot] = commands.get_disk_boot_info
watchdogs.scripts[watchdogs.signals.diskhome] = commands.get_disk_home_info

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

watchdogs.callbacks[watchdogs.signals.temp] = function(widget, stdout)
  awesome.emit_signal("sysstat::temp", tonumber(stdout))
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


local disk_callback = function(sig, widget, stdout)

  local used = stdout:match('(.*) ')
  local available  = stdout:match(' (.*)')
  awesome.emit_signal(sig, tonumber(used), tonumber(available))
end

watchdogs.callbacks[watchdogs.signals.diskroot] = function(widget, stdout)
  disk_callback("sysstat:disk_root", widget, stdout)
end

watchdogs.callbacks[watchdogs.signals.diskhome] = function(widget, stdout)
  disk_callback("sysstat:disk_home", widget, stdout)
end

watchdogs.callbacks[watchdogs.signals.diskboot] = function(widget, stdout)
  disk_callback("sysstat:disk_boot", widget, stdout)
end

watchdogs.run = function(watchdog, interval)
    awful.widget.watch(watchdogs.scripts[watchdog], interval, watchdogs.callbacks[watchdog])
end


watchdogs.init = function()
    watchdogs.run(watchdogs.signals.ram, 2)
    watchdogs.run(watchdogs.signals.cpu, 2)
    watchdogs.run(watchdogs.signals.pow, 2)

    watchdogs.run(watchdogs.signals.temp, 30)

    watchdogs.run(watchdogs.signals.diskroot, 60)
    watchdogs.run(watchdogs.signals.diskhome, 60)
    watchdogs.run(watchdogs.signals.diskboot, 60)
  --   watchdogs.run(watchdogs.signals.ps, 2)
end

return watchdogs
