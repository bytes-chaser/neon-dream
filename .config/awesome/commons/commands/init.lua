
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
  zsh -c "{cat /sys/class/power_supply/BAT0/status;cat /sys/class/power_supply/BAT0/capacity} | paste -d ' ' -s" | awk '{printf "#" $1 "__" $2 "#"}'
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
  zsh -c "ps -eo pid,cmd,%mem,%cpu --sort=-%cpu | head -6 | tail -5"
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

commands.shutdown = 'sudo shutdown now'

commands.reboot = 'sudo reboot'

commands.set_svol = function(audio_val)
  return "amixer set Master " .. audio_val .. "%"
end

commands.set_brightness = function(brightness_val)
  return "brightnessctl s " .. brightness_val .. "%"
end

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
