local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local dpi         = beautiful.xresources.apply_dpi

profile = {
  pic = function(shape)
    return wibox.widget(
    {
        image      = beautiful.profile_pic,
        widget     = wibox.widget.imagebox,
        clip_shape = shape
    }
  )
  end
  ,
  name = function(size)
    return wibox.widget{
        id            = "profile",
        text          = user,
        align         = "center",
        opacity       = 1,
        font          = beautiful.font_famaly .. " Bold " .. tostring(size),
        widget        = wibox.widget.textbox,
    }
  end
}


return wibox.widget(
  {
    {
      profile.pic(gears.shape.circle),
      {
        profile.name(12),
        widget = wibox.container.margin,
        left   = dpi(5)
      },
      layout = wibox.layout.fixed.horizontal
    },
    widget        = wibox.container.background,
    forced_width  = dpi(300),
    forced_height = dpi(50),
  }
)
