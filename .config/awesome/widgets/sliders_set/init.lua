local awful           = require("awful")
local gears           = require("gears")
local wibox           = require("wibox")
local commands        = require("commons.commands")
local icons           = require("commons.icons")
local slider_factory  = require("widgets.control_slider")

local sun_icon = icons.wbi("", 32)

local vol_sl = slider_factory.create_with_events(0, 100, commands.svol,
function(stdout)
  return tonumber(stdout)
end,
function(val)
  awful.spawn(commands.set_svol(val), false)
end
)

local music_icon = icons.wbi("", 32)

local brightness_sl = slider_factory.create_with_events(10, 100, commands.brightness,
function(stdout)
  return tonumber(stdout)
end,
function(val)
    awful.spawn(commands.set_brightness(val), false)
end)

return wibox.widget{
  {
    {
      music_icon,
      vol_sl,
      layout = wibox.layout.fixed.horizontal
    },
    {
      sun_icon,
      brightness_sl,
      layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.flex.vertical
  },
  widget = wibox.container.background
}
