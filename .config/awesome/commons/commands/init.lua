
local commands = {}

commands.svol =
[[
  zsh -c "amixer get Master | tail -1 | awk '{print $4}' | grep -o '[0-9]\+'"
]]

commands.brightness =
[[
  zsh -c "brightnessctl i | head -2 | tail -1 | awk '{printf $4}' | grep -o '[0-9]\+'"
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

commands.mv = function(name1, name2)
  return "mv " .. name1 .. ' ' .. name2
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
  return "ls -l " .. path .. " | awk '{print $NF}' | tail -n +2"
end

commands.get_files_watchdog = function(path)
  return 'zsh -c "ls -l ' .. path .. ' | awk \'{printf $9 \\"\\n\\"}\'"'
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


return commands
