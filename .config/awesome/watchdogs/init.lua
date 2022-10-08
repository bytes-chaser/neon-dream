local awful = require("awful")
local beautiful = require("beautiful")
local commands = require("commons.commands")
local utils = require("watchdogs.utils")

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
watchdogs.signals.docker = watchdogs.signals.prfx .. 'docker'
watchdogs.signals.themes = watchdogs.signals.prfx .. 'themes'

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
watchdogs.scripts[watchdogs.signals.docker] = commands.docker_containers
watchdogs.scripts[watchdogs.signals.themes] = commands.get_files_watchdog(theme_folder)

watchdogs.callbacks[watchdogs.signals.ram] = function(widget, stdout)
    local total = stdout:match('#(.*)__')
    local used  = stdout:match('__(.*)#')
    local val = math.floor(100 * (tonumber(used) / tonumber(total)))
    awesome.emit_signal("sysstat::ram", val, '%', total, used)
end

watchdogs.callbacks[watchdogs.signals.cpu] = function(widget, stdout)
    awesome.emit_signal("sysstat::cpu", tonumber(stdout), '%')
end

watchdogs.callbacks[watchdogs.signals.pow] = function(widget, stdout)
  local capacity  = stdout:match(' (.*)')
  local status    = stdout:match('(.*) ')
  awesome.emit_signal("sysstat::pow", tonumber(capacity), '%', status)
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

    local lines = {}
    for w in stdout:gmatch("[^\r\n]+") do
        local included = check_excluded_repo_path(w)
        if included then
            table.insert(lines, w)
        end
    end

    utils.procedures.caching(cfg.repos_scan.cache_file, "update::repos", lines, function(item, callback)
        local path = item:match('(.*)/.git')

        awful.spawn.easy_async_with_shell(commands.git_repo_info(path), function(out)
            local url = out:match('Fetch URL: (.+)%.git\n%s+Push') or 'undefined'

            local source_icon = ""

            if(url == nil) then
                source_icon = ""
            elseif url:find('github') then
                source_icon = ''
            elseif url:find('gitlab') then
                source_icon = ""
            elseif url:find('bitbucket') then
                source_icon = ""
            end

            local formatted_path = string.gsub(path, home_folder, "~")
            local line_data = {
                'git',
                formatted_path,
                path:match('.+/(.+)$'),
                url,
                '',
                source_icon
            }
        callback(line_data)
        end)
    end)
end

watchdogs.callbacks[watchdogs.signals.temp] = function(widget, stdout)
  awesome.emit_signal("sysstat::temp", tonumber(stdout), '°C')
end

watchdogs.callbacks[watchdogs.signals.sync_packages] = function()
  local date_table = os.date("*t")
  local hour, minute, second = date_table.hour, date_table.min, date_table.sec

  local year, month, day = date_table.year, date_table.month, date_table.day   -- date_table.wday to date_table.day
  local result = string.format("%d-%d-%d %d:%d:%d", year, month, day, hour, minute, second, ms)
  awful.spawn.with_shell("echo '" .. result .. "' > " .. home_folder .. '/.cache/awesome/.packages_sync_time')


  utils.procedures.caching(cfg.track_packages.cache_file, "sysstat::package_add", cfg.track_packages.names, function(package, callback)
      local check_updates = "pacman -Qu " .. package .. " | awk '{printf $4}'"
      local check_current = "pacman -Q "  .. package .. " | awk '{printf $2}'"

      awful.spawn.easy_async_with_shell(check_updates, function(out)
          local is_outdated = (#out == 0)
          local avail_version = is_outdated and '' or out
          local avail_col = beautiful.palette_positive
          local avail_font = (is_outdated and '16' or '12')

          awful.spawn.easy_async_with_shell(check_current, function(version)
              local color = is_outdated and beautiful.palette_negative or beautiful.palette_positive
              local line_data = {
                  package:gsub("[\r\n]", ""),
                  color,
                  version:gsub("[\r\n]", ""),
                  avail_col,
                  avail_font,
                  avail_version:gsub("[\r\n]", "")
              }
              callback(line_data)
          end)
      end)
  end)

end

watchdogs.callbacks[watchdogs.signals.ps] = function(widget, stdout)

  local ps_info = {}
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
  local total = used + available
  local val = math.ceil(100 * (tonumber(used) / tonumber(total)))
  awesome.emit_signal(sig, val, '%', used, total)
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

watchdogs.callbacks[watchdogs.signals.docker] = function(widget, stdout)
    awful.spawn.with_shell(commands.create_text_file(cfg.docker.cache_file))

    stdout = stdout:gsub("______", "___Noinfo___")
    stdout = stdout:gsub(", ", "@")

    local lines = nd_utils.split(stdout, '\n')

    local containers = {}
    for _, value in ipairs(lines) do
        if #value > 0 then
            value = nd_utils.trim(value)
            table.insert(containers, value)
        end
    end

    utils.procedures.caching(cfg.docker.cache_file, "sysstat::docker_container_add", containers, function(value, callback)
        local line_data = nd_utils.split(nd_utils.trim(value), "___")

        line_data[5] = line_data[5]:match("^%w+")

        local time = line_data[6]:match("^%d+%s+%w+")

        if time == nil then
            line_data[6] = line_data[6]:match("About%s+a%w*%s+(%w+)")
        else
            line_data[6] = time
        end

        line_data[6] = line_data[6]:gsub("%s", "___")

        callback(line_data)
    end)
end

watchdogs.callbacks[watchdogs.signals.themes] = function(widget, stdout)
    local themes = {}
    for w in stdout:gmatch("[^\r\n]+") do
        table.insert(themes, w)
    end

    utils.procedures.caching(cfg.theme.cache_file, "update::themes", themes, function(theme_name, callback)
        callback({
            theme_name,
            theme_folder .. theme_name .. '/background.png'
        })
    end)
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

    watchdogs.run(watchdogs.signals.docker, 20)
    watchdogs.run(watchdogs.signals.themes, 60)

    if nd_utils.is_file_exists(cfg.track_packages.cache_file) == false then
        awful.spawn.easy_async_with_shell(
                watchdogs.scripts[watchdogs.signals.sync_packages] ,
                watchdogs.callbacks[watchdogs.signals.sync_packages]
        )
    end

    if nd_utils.is_file_exists(cfg.repos_scan.cache_file) == false then

        awful.spawn.easy_async_with_shell(
                watchdogs.scripts[watchdogs.signals.git_repos],
                watchdogs.callbacks[watchdogs.signals.git_repos]
        )
    end
    
end

return watchdogs
