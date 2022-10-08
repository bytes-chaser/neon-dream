local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local shapes    = require("commons.shape")
local wibox     = require("wibox")

return {
  create = function(record)
    local name = record.name
    local cpu  = record.cpu
    local mem  = record.mem

    return wibox.widget {
      widget = wibox.container.margin,
      margins = dpi(5),
      {
        id = 'marg',
        widget = wibox.container.background,
        shape  = shapes.default_frr,
        bg = beautiful.palette_c6,
        {
          id      = 'i_marg',
          widget  = wibox.container.margin,
          top     = dpi(5),
          bottom  = dpi(5),
          left    = dpi(10),
          right   = dpi(10),
          {
            id = 'box',
            {
              id = "name",
              widget = wibox.widget.textbox,
              markup = "<span foreground='" .. beautiful.palette_c1 .."'>" .. name  .."</span>"
            },
            {
              id = "cpu",
              widget = wibox.widget.textbox,
              markup = "<span foreground='" .. beautiful.palette_c1 .."'>" .. cpu  .."</span>"
            },
            {
              widget = wibox.widget.textbox,
              id = "mem",
              markup = "<span foreground='" .. beautiful.palette_c1 .."'>" .. mem  .."</span>"
            },
            layout = wibox.layout.flex.horizontal,
          }
        }
      }
    }
  end
}
