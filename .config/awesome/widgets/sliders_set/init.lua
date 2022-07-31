local awful           = require("awful")
local gears           = require("gears")
local wibox           = require("wibox")
local commands        = require("commons.commands")
local icons           = require("commons.icons")
local slider_factory  = require("widgets.control_slider")
local beautiful   = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi


local sun_icon = icons.wbic("", 20, beautiful.pallete_c1)

local vol_sl = slider_factory.create_with_events(0, 100, commands.svol,
function(stdout)
  return tonumber(stdout)
end,
function(val)
  awful.spawn(commands.set_svol(val), false)
end
)

local music_icon = icons.wbic("", 20, beautiful.pallete_c1)

local brightness_sl = slider_factory.create_with_events(10, 100, commands.brightness,
function(stdout)
  return tonumber(stdout)
end,
function(val)
    awful.spawn(commands.set_brightness(val), false)
end)

return wibox.widget{
  {
    widget = wibox.container.background
  },
  {
    nil,
    {
      {
        widget = wibox.container.rotate,
        direction     = 'east',
        vol_sl
      },
      widget = wibox.container.margin,
      bottom = dpi(15)
    },
    music_icon,
    layout = wibox.layout.align.vertical
  },
  {
    nil,
    {
      {
        widget = wibox.container.rotate,
        direction     = 'east',
        brightness_sl
      },
      widget = wibox.container.margin,
      bottom = dpi(15)
    },
    sun_icon,
    layout = wibox.layout.align.vertical
  },
  {
    widget = wibox.container.background
  },
  layout = wibox.layout.flex.horizontal
}
