local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local gears     = require("gears")

local factory = {}

factory.create = function(min, max)
  return wibox.widget {
      bar_shape           = gears.shape.default_frr,
      bar_height          = dpi(5),
      bar_color           = beautiful.fg_normal,
      handle_color        = beautiful.palette_c4,
      handle_shape        = gears.shape.circle,
      handle_width        = dpi(20),
      handle_border_color = beautiful.palette_c3,
      handle_border_width = dpi(2),
      minimum             = min,
      maximum             = max,
      value               = 0,
      widget              = wibox.widget.slider,
  }

end

factory.create_with_events = function(min, max, init_cmd, init_cmd_callback, on_val_change)
  local sl = factory.create(min, max)

  awful.spawn.easy_async(init_cmd,
  function(stdout)
    sl:set_value(init_cmd_callback(stdout))
  end)

  sl:connect_signal("property::value", function()
    on_val_change(sl.value)
  end)
  return sl
end

return factory
