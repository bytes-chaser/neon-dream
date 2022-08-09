local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local icons       = require("commons.icons")

local bar         = require("widgets.pbars.pbar_std.progress_bar")
local lbl         = require("widgets.pbars.pbar_std.progress_label")


local get_layout = function(parameters)
  local direction = parameters.direction
  return (direction == 'north' or direction == 'south')
        and wibox.layout.align.horizontal
        or wibox.layout.align.vertical
end


return {

  set_val = function(pbar, pbar_parameters, val)
      pbar[2].pb.value = val
  end,


  set_label_text = function(element, text)
      element[3].markup = "<span foreground='" .. beautiful.fg_focus .."'>" .. text .. "</span>"
  end,


  create = function(icon, parameters)
    local icon = icons.wbi(icon, parameters.title_size or beautiful.pbar_icon_size)

    local pbar = bar.create(parameters)

    if parameters.width then
      pbar.pb.forced_width = width
      pbar.forced_width    = width
    end

    if parameters.heigh then
      pbar.pb.forced_height = width
      pbar.forced_height    = width
    end

    local label = lbl.create()

    return {
      icon,
      pbar,
      label,
      layout = get_layout(parameters)
    }
  end
}
