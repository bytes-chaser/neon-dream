local wibox           = require("wibox")
local beautiful       = require("beautiful")
local dpi             = beautiful.xresources.apply_dpi
local shape_utils     = require("commons.shape")

local card = {}

card.create = function(content)
  return wibox.widget{
    {
      {
        content,
        widget = wibox.container.margin,
        margins = dpi(15),
      },
      widget = wibox.container.background,
      bg = beautiful.palette_c6,
    },
    widget = wibox.container.margin,
    margins = dpi(10),
  }
end


card.create_with_header = function(header, content)
  return wibox.widget{
    {
      {
        {
              markup   = "<span foreground='" .. beautiful.fg_focus .."'>" .. header .."</span>",
              font = beautiful.font_famaly .. '14',
              align = "center",
              opacity = 1,
              widget = wibox.widget.textbox,
        },
        shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, false, false),
        widget = wibox.container.background,
        bg = beautiful.palette_c7,
      },
      {
        {
          content,
          widget = wibox.container.margin,
          margins = dpi(15),
        },
        shape = shape_utils.partially_rounded_rect(beautiful.rounded, false, false, true, true),
        widget = wibox.container.background,
        bg = beautiful.palette_c6,
      },
      layout = wibox.layout.align.vertical
    },
    widget = wibox.container.margin,

    margins = dpi(10),
  }
end

return card
