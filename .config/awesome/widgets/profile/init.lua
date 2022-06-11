local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local dpi         = beautiful.xresources.apply_dpi
local shape_utils = require("commons.shape")

local monitor_dock = wibox(
{
    visible = true,
    ontop = false,
    height = dpi(150),
    width = dpi(250),
    bg = beautiful.col_transparent,
    type = "dock",
    border_width = dpi(4),
    border_color = beautiful.border_focus,
    shape =  shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
    screen = screen.primary,
})


monitor_dock:setup{
  {
    {
        image = beautiful.profile_pic,
        widget = wibox.widget.imagebox,
        forced_width = dpi(100),
        forced_height = dpi(100),
        clip_shape = shape_utils.circle(dpi(350))
    },
    widget = wibox.container.place,
  },
  {
    {
        id            = "profile",
        text          = user,
        align         = "center",
        opacity       = 1,
        font          = beautiful.font_famaly .. " Bold 32",
        widget        = wibox.widget.textbox,
    },
    layout = wibox.layout.flex.horizontal
  },
  layout = wibox.layout.flex.horizontal

}

awful.placement.top_left(monitor_dock, {honor_workarea=true, margins={left = 30}})

return monitor_dock
