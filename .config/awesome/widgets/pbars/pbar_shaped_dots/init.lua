local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local icons       = require("commons.icons")

local pb          = require("widgets.pbars.pbar_shaped_dots.progress_bar")
local lbl         = require("widgets.pbars.pbar_shaped_dots.progress_label")

local sw_bg = function(pbar, index, color)

    local r = pbar[2]:get_children_by_id("arr")[1]:get_children()[index]:get_children_by_id("point")[1]
    r.bg = color
end


return {

  set_val = function(pbar, pbar_parameters, val)
      for i = 1, 10 do
          mb.sw_bg(pbar, i, i <= val and (pbar_parameters.active_color or beautiful.pbar_active_color) or (pbar_parameters.bg_color or beautiful.pbar_bg_color))
      end
  end


  create = function(icon, parameters)
      local icon  = icons.wbi(icon, beautiful.pbar_icon_size)
      local pbar  = pb.create(parameters)
      local label = lbl.create()

      return {
        icon,
        pbar,
        label,
        layout = wibox.layout.align.horizontal
      }
    end

}
