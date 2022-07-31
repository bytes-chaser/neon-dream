local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local icons       = require("commons.icons")

local mb = {}

mb.set_val = function(pbar, pbar_parameters, val)
    pbar[2].pb.value = val
end

mb.get_layout = function(parameters)
  local direction = parameters.direction
  local layout = wibox.layout.align.vertical
  if direction == 'north' or direction == 'south' then
    layout = wibox.layout.align.horizontal
  end
  return layout
end

mb.set_label_text = function(element, text)
    element[3].markup = "<span foreground='" .. beautiful.fg_focus .."'>" .. text .. "</span>"
end


mb.create = function(icon, parameters)
  local pbar = wibox.widget {
    {
      id = "pb",
      max_value     = parameters.max_val,
      min_value     = 0,
      value         = 0,
      shape         = gears.shape.rounded_bar,
      bar_shape     = gears.shape.rounded_bar,
      background_color = beautiful.bg_normal,
      color = beautiful.bg_urgent,
      margins = parameters.margin,
      paddings = 3,
      border_width  = 1,
      bar_border_width = 1,
      border_color  = beautiful.fg_normal,
      widget        = wibox.widget.progressbar,
    },
    direction     = parameters.direction,
    layout        = wibox.container.rotate,
  }

  if parameters.width then
    pbar.pb.forced_width = width
    pbar.forced_width = width
  end

  if parameters.heigh then
    pbar.pb.forced_height = width
    pbar.forced_height = width
  end


  local label = wibox.widget{
      id            = "text_status",
      markup        = "<span foreground='" .. beautiful.fg_focus .."'>" .. "0%" .. "</span>",
      align         = "center",
      forced_width  = dpi(80),
      opacity       = 1,
      font          = beautiful.font_famaly .. " Bold 10",
      widget        = wibox.widget.textbox,
  }

  return {
    icons.wbi(icon, parameters.title_size or beautiful.pbar_icon_size),
    pbar,
    label,
    layout = mb.get_layout(parameters)
  }
end

return mb
