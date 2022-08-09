local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi
local icons     = require("commons.icons")


return {
  create_point = function(index, shape, bg_color, p_heigth, p_width, p_margin)
      return wibox.widget{
          {
              icons.wbi(index, 0),

              id            = "point",
              widget        = wibox.container.background,
              forced_height = dpi(p_heigth),
              forced_width  = dpi(p_width),
              shape         = shape,
              bg            = bg_color,
          },
          id     = "mbox",
          left   = dpi(p_margin),
          widget = wibox.container.margin,
      }
  end
}
