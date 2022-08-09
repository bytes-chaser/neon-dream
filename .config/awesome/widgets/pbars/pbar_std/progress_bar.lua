
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")

return {
  create = function(parameters)
    return wibox.widget {
      {
        id = "pb",
        widget           = wibox.widget.progressbar,

        max_value        = parameters.max_val,
        margins          = parameters.margin,

        min_value        = 0,
        value            = 0,

        background_color = beautiful.bg_normal,
        color            = beautiful.bg_urgent,
        border_color     = beautiful.fg_normal,

        shape            = gears.shape.rounded_bar,
        bar_shape        = gears.shape.rounded_bar,

        paddings         = 3,
        border_width     = 1,
        bar_border_width = 1,
      },
      direction     = parameters.direction,
      layout        = wibox.container.rotate,
    }
  end
}
