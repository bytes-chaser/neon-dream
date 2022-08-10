local awful       = require("awful")
local dpi         = require("beautiful").xresources.apply_dpi
local wibox       = require("wibox")
local gears       = require("gears")
local icons       = require("commons.icons")
local commands    = require("commons.commands")

local button = function(symb, size, command)
  icon = icons.wbi(symb, size)
  icon:buttons(gears.table.join(awful.button({ }, 1, command)))
return icon
end


local create_btn_callback = function(on_play_cmd, on_pause_cmd)
  return function()
    local command = ""

    if player_works then
      command = on_play_cmd
    else
      command = on_pause_cmd
    end

    awful.spawn.with_shell(command)
  end
end

return {

  create = function(symb, size, cmd, pause_cmd)
    return button(symb, size, create_btn_callback(cmd, pause_cmd))
  end
}
