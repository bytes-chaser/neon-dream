local awful = require("awful")
local commands = require("commons.commands")

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
watchdogs.signals.weather = watchdogs.signals.prfx .. 'weather'
watchdogs.signals.git_repos = watchdogs.signals.prfx .. 'git_repos'
watchdogs.signals.sync_packages = watchdogs.signals.prfx .. 'sync'
watchdogs.signals.diskroot = watchdogs.signals.prfx .. 'diskroot'
watchdogs.signals.diskboot = watchdogs.signals.prfx .. 'diskboot'
watchdogs.signals.diskhome = watchdogs.signals.prfx .. 'diskhome'

watchdogs.scripts[watchdogs.signals.ram] = commands.ram
watchdogs.scripts[watchdogs.signals.cpu] = commands.cpu
watchdogs.scripts[watchdogs.signals.pow] = commands.pow
watchdogs.scripts[watchdogs.signals.temp] = commands.temp
watchdogs.scripts[watchdogs.signals.ps] = commands.top_ps
watchdogs.scripts[watchdogs.signals.weather] = commands.weather_info
watchdogs.scripts[watchdogs.signals.git_repos] = commands.git_repos(cfg.repos_scan.scan_root_path)
watchdogs.scripts[watchdogs.signals.sync_packages] = commands.sync_packages
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

local check_excluded_repo_path = function(w)

  for k, path in pairs(cfg.repos_scan.exclude_paths) do
    if w:find(path) then
        return false
    end
  end

  return true
end

watchdogs.callbacks[watchdogs.signals.git_repos] = function(widget, stdout)

  local repos = {}
  local index = 1
  for w in stdout:gmatch("[^\r\n]+") do

    local included = check_excluded_repo_path(w)

    if included then
      repo_info = {}
      repo_info.vcs = 'git'
      repo_info.icon = ''
      repo_info.path = w:match('(.*)/.git')
      repo_info.name = repo_info.path:match('.+/(.+)$')
      repos[index] = repo_info
      index = index + 1
    end
  end
  awesome.emit_signal("sysstat::git_repos", repos)
end

watchdogs.callbacks[watchdogs.signals.temp] = function(widget, stdout)
  awesome.emit_signal("sysstat::temp", tonumber(stdout))
end

watchdogs.callbacks[watchdogs.signals.sync_packages] = function(widget, stdout, stderr, exitreason, exitcode)

  local date_table = os.date("*t")
  local hour, minute, second = date_table.hour, date_table.min, date_table.sec

  local year, month, day = date_table.year, date_table.month, date_table.day   -- date_table.wday to date_table.day
  local result = string.format("%d-%d-%d %d:%d:%d", year, month, day, hour, minute, second, ms)


  awful.spawn.with_shell("echo '" .. result .. "' > " .. home_folder .. '/.config/awesome/.packages_sync_time')
  awesome.emit_signal("sysstat::package_sync", result)

end

watchdogs.callbacks[watchdogs.signals.ps] = function(widget, stdout)

  ps_info = {}
  local index  = 1
  for w in stdout:gmatch("%S+") do
    local info = {}
    info.name = w:match("#(.+)-")
    info.cpu = w:match("-(.+)__")
    info.mem = w:match("__(.+)")
    ps_info[index] = info
    index = index + 1

  end
  awesome.emit_signal("sysstat::ps", ps_info)

end


local disk_callback = function(sig, widget, stdout)

  local used = stdout:match('(.*) ')
  local available  = stdout:match(' (.*)')
  awesome.emit_signal(sig, tonumber(used), tonumber(available))
end


watchdogs.callbacks[watchdogs.signals.weather] = function(widget, stdout)
  local status = stdout:match('code":([0-9]+)},"wind_mph')
  local temperature = stdout:match('temp_c":(.+),"temp_f')
  awesome.emit_signal("data:weather", status, temperature)
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

    watchdogs.run(watchdogs.signals.ps, 2)

    watchdogs.run(watchdogs.signals.temp, 30)

    watchdogs.run(watchdogs.signals.diskroot, 5)
    watchdogs.run(watchdogs.signals.diskhome, 5)
    watchdogs.run(watchdogs.signals.diskboot, 5)

    watchdogs.run(watchdogs.signals.git_repos, 3600)
    watchdogs.run(watchdogs.signals.weather, 120)
    watchdogs.run(watchdogs.signals.sync_packages, 3600)

end

return watchdogs
