local wibox       = require("wibox")
local beautiful   = require("beautiful")

local month_style    = require("widgets.calendar.styles.month")
local normal_style   = require("widgets.calendar.styles.normal")
local header_style   = require("widgets.calendar.styles.header")
local focus_style    = require("widgets.calendar.styles.focus")
local weekday_style  = require("widgets.calendar.styles.weekday")


local calendar = {
  styles = {
    month   = month_style,
    normal  = normal_style,
    focus   = focus_style,
    header  = header_style,
    weekday = weekday_style,
  }
}


calendar.decorate_cell = function(widget, flag, date)
    if flag=="monthheader" and not calendar.styles.monthheader then
        flag = "header"
    end

    local props = calendar.styles[flag] or {}

    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    local d = {
      year  = date.year,
      month = date.month or 1,
      day   = date.day or 1
    }


    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_fg = nd_utils.arr_contains(cfg.widgets.calendar.weekend_days_indexes, weekday)
                        and beautiful.palette_positive
                        or (props.fg_color or beautiful.palette_c2)

    return wibox.widget {
        {
            widget,
            margins = props.padding or 3,
            widget  = wibox.container.margin
        },
        shape        = props.shape,
        fg           = default_fg,
        bg           = props.bg_color or beautiful.palette_c6,
        widget       = wibox.container.background
    }
end

calendar.create = function()
  return wibox.widget {
      date          = os.date("*t"),
      long_weekdays = true,
      start_sunday  = cfg.widgets.calendar.week_started_on_sunday,
      fn_embed      = calendar.decorate_cell,
      widget        = wibox.widget.calendar.month
  }
end

return calendar
