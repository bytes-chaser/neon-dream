local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")

local icons       = require("commons.icons")

local mb = {}

mb.set_val = function(pbar, pbar_parameters, val)
    pbar[2].value = val
end


mb.create = function(icon, parameters)
  local pbar = wibox.widget {
    max_value     = parameters.max_val,
    min_value     = 0,
    value         = 0,
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    background_color = beautiful.bg_normal,
    color = beautiful.bg_urgent,
    margins = parameters.margin,
    paddings = 3,
    border_width  = 2,
    bar_border_width = 1,
    border_color  = beautiful.fg_normal,
    widget        = wibox.widget.progressbar,
  }

  local label = wibox.widget{
      id            = "text_status",
      text          = "0%",
      align         = "center",
      forced_width  = dpi(80),
      opacity       = 1,
      font          = beautiful.font_famaly .. " Bold 16",
      widget        = wibox.widget.textbox,
  }

  return {
    icons.wbi(icon, beautiful.pbar_icon_size),
    pbar,
    label,
    layout = wibox.layout.align.horizontal
  }
end

return mb
