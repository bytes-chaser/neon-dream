local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local dpi         = beautiful.xresources.apply_dpi
local shape_utils = require("commons.shape")

profile = {}
profile.pic = function(width, height, shape)
  return wibox.widget(
  {
    {
        image = beautiful.profile_pic,
        widget = wibox.widget.imagebox,
        forced_width = dpi(width),
        forced_height = dpi(height),
        clip_shape = shape
    },
    widget = wibox.container.place,
  }
)
end

profile.name = function (size)
  return wibox.widget{
      id            = "profile",
      text          = user,
      align         = "center",
      opacity       = 1,
      font          = beautiful.font_famaly .. " Bold " .. tostring(size),
      widget        = wibox.widget.textbox,
  }
end

local profile_dock = wibox.widget(
  {
    {
      nil,
      profile.pic(100, 100, shape_utils.circle(dpi(350))),
      profile.name(32),
      layout = wibox.layout.align.vertical
    },
    widget = wibox.container.background,
    forced_width = dpi(300),
    forced_height = dpi(50),
  }
)

return profile_dock
