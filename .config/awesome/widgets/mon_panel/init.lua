local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local dpi         = beautiful.xresources.apply_dpi
local shape_utils = require("commons.shape")
local mb          = require("widgets.pbars.pbar_std")

local g_params = {
  max_val     = 100,
  bars_margin = 5,
  margin      = 15,
  direction   = 'north',
}

local get_layout = function(parameters)
  return (direction == 'north' or direction == 'south')
          and wibox.layout.flex.vertical
          or wibox.layout.flex.horizontal
end


return {

  default_params = function()
    return nd_utils.copy(g_params)
  end,


  create = function(params, bundles)
    local parameters = params or g_params

    local widget_table = {
      layout = get_layout(parameters)
    }

    for _, bundle in pairs(bundles) do
      local icon     = bundle.icon
      local signal   = bundle.signal

      local pbar = mb.create(icon, parameters)

      awesome.connect_signal(signal, function(val, postfix)
        mb.set_val(pbar, parameters, val)
        mb.set_label_text(pbar, val .. postfix)
      end)

      local pbar_widget = {
          pbar,
          widget  = wibox.container.margin,
          margins = dpi(parameters.bars_margin)
      }

      table.insert(widget_table, pbar_widget)
    end

    return wibox.widget({
      forced_height = dpi(130),
      forced_width  = dpi(400),
      widget        = wibox.container.background,

      widget_table
    })
  end
}
