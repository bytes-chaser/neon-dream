
local commands = {}
commands.ram =
[[
    zsh -c "free -m | grep Mem: | awk '{printf \"#%d__%d#\", $2, $3}'"
]]

commands.cpu =
[[
    zsh -c "top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print 100-$8}'"
]]

commands.pow =
[[
  zsh -c "{cat /sys/class/power_supply/BAT0/status | sed 's/ //g';cat /sys/class/power_supply/BAT0/capacity} | paste -d ' ' -s" | awk '{printf "#" $1 "__" $2 "#"}'
]]

commands.svol =
[[
  zsh -c "amixer get Master | tail -1 | awk '{print $4}' | grep -o '[0-9]\+'"
]]

commands.brightness =
[[
  zsh -c "brightnessctl i | head -2 | tail -1 | awk '{printf $4}' | grep -o '[0-9]\+'"
]]

commands.top_ps =
[[
  zsh -c "top -b|head -12 | tail -5 | awk '{printf \"#\" $12 \"-\" $9 \"__\" $10 \" \"}'"
]]

commands.player_toggle =
[[
  zsh -c "playerctl play-pause"
]]

commands.player_next =
[[
  zsh -c "playerctl next"
]]

commands.player_prev =
[[
  zsh -c "playerctl previous"
]]

commands.sync_packages =
[[
  zsh -c "sudo pacman -Sy ; yay -Sy"
]]


commands.shutdown = 'sudo shutdown now'

commands.reboot = 'sudo reboot'

commands.set_svol = function(audio_val)
  return "amixer set Master " .. audio_val .. "%"
end

commands.set_brightness = function(brightness_val)
  return "brightnessctl s " .. brightness_val .. "%"
end

commands.git_repos = function(scan_root)
  return "find " .. scan_root .. " -name '.git'"
end

commands.git_repo_info = function(path)
  return "git -C " .. path .. " remote show origin"
end

commands.get_files = function(path)
  return "ls -l " .. path .. " | awk '{printf $9 \"\\n\"}'"
end

commands.delete_file = function(path)
  return "rm " .. path
end

commands.get_text = function(path)
  return "cat " .. path
end

commands.create_text_file = function(path)
  return "echo -n '' > " .. path
end

commands.append_text = function(path, text)
  return "echo -n '" ..text .. "' >> " .. path
end

commands.get_text_sorted = function(path, col, direction)
  local cmd = (direction and 'desc' == direction) and "sort -r -k " or "sort -k "
  return cmd .. tostring(col) .. ' ' .. path
end

commands.weather_info = 'curl https://api.weatherapi.com/v1/current.json?key=' .. os.getenv("WEATHER_API_COM_API_KEY") .. '&q='.. os.getenv("WEATHER_API_COM_CITY") ..'&aqi=no'

commands.get_disk_root_info =
  [[
    zsh -c "df -B 1MB / | tail -1 | awk '{printf \"%d %d\", $3, $4}'"
  ]]

commands.get_disk_boot_info =
  [[
    zsh -c "df -B 1MB /boot | tail -1 | awk '{printf \"%d %d\", $3, $4}'"
  ]]

commands.get_disk_home_info =
  [[
    zsh -c "df -B 1MB /home | tail -1 | awk '{printf \"%d %d\", $3, $4}'"
  ]]

commands.temp =
  [[
    zsh -c "sensors | grep Package | awk '{printf \"%d\", $4}'"
  ]]

return commands
