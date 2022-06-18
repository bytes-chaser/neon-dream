local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local pb          = require("widgets.progress_bar")
local icons       = require("commons.icons")

local mb = {}

mb.sw_bg = function(pbar, index, color)

    local r = pbar[2]:get_children_by_id("arr")[1]:get_children()[index]:get_children_by_id("point")[1]
    r.bg = color
end


mb.set_val = function(pbar, pbar_parameters, val)
    for i = 1, 10
        do
            mb.sw_bg(pbar, i, i <= val and (pbar_parameters.active_color or beautiful.pbar_active_color) or (pbar_parameters.bg_color or beautiful.pbar_bg_color))
        end
end


mb.create = function(icon, parameters)
  local pbar = pb.create_shaped_points_pbar(parameters)
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
