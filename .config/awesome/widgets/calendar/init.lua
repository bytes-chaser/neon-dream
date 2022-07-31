local wibox       = require("wibox")
local gears       = require("gears")
local shape_utils = require("commons.shape")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi

local calendar = {}

calendar.styles = {}
calendar.styles.month   = { padding      = 5,
                   border_width = 2,
                   shape  = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true)
}
calendar.styles.normal  = { shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true) }
calendar.styles.focus   = {
                   fg_color = beautiful.pallete_c1,
                   bg_color = beautiful.pallete_c7,
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true)
}
calendar.styles.header  = { fg_color = beautiful.pallete_c1,
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true)
}
calendar.styles.weekday = { fg_color = beautiful.pallete_c4,
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true)
}


calendar.decorate_cell = function(widget, flag, date)
    if flag=="monthheader" and not calendar.styles.monthheader then
        flag = "header"
    end

    local props = calendar.styles[flag] or {}

    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_bg = (weekday==0 or weekday==6) and "#232323" or "#383838"
    local ret = wibox.widget {
        {
            widget,
            margins = (props.padding or 5) + (props.border_width or 0),
            widget  = wibox.container.margin
        },
        shape        = props.shape,
        fg           = props.fg_color or beautiful.pallete_c2,
        bg           = props.bg_color or beautiful.palette_c6,
        widget       = wibox.container.background
    }
    return ret
end

calendar.create = function()
  return wibox.widget {
      date          = os.date("*t"),
      font          = "Monospace 10",
      long_weekdays = true,
      fn_embed = calendar.decorate_cell,
      widget        = wibox.widget.calendar.month
  }
end

return calendar
