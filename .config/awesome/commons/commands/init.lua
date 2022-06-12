
local commands = {}
commands.ram =
[[
    bash -c "free -m | grep Mem: | awk '{printf \"#%d__%d#\", $2, $3}'"
]]

commands.cpu =
[[
    bash -c "top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print 100-$8}'"
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

commands.set_svol = function(audio_val)
  return "amixer set Master " .. audio_val .. "%"
end

commands.set_brightness = function(brightness_val)
  return "brightnessctl s " .. brightness_val .. "%"
end
return commands
