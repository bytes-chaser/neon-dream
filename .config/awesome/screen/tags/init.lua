local awful         = require("awful")
local beautiful     = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi
local gears         = require("gears")
local wibox         = require("wibox")

require("screen.tags.buttons")

return {

  create = function(s)


    local name_section = {
        {
          {
              id     = 'text_role',
              widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(8),
        widget  = wibox.container.margin
    }


    local widget_template = {
      id     = 'background_role',
      widget = wibox.container.background,
      {
        widget   = wibox.container.margin,
        margins  = {
            top     = 5,
            bottom  = 5,
            left    = 6,
            right   = 6,
        },
        {
          name_section,
          bg     = beautiful.palette_c7,
          shape  = cfg.tags.shape,
          widget = wibox.container.background
        },
      },
    }


    return awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,

        layout = {
          spacing = dpi(10),
          layout  = wibox.layout.fixed.horizontal
        },

        widget_template = widget_template
    }
  end
}
