local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local dpi         = beautiful.xresources.apply_dpi
local pb          = require("widgets.progress_bar")
local shape_utils = require("commons.shape")
local mb          = require("widgets.monitor_stat_bar_std")

local g_params = {}
g_params.max_val = 100
g_params.bars_margin = 5
g_params.margin = 15
g_params.direction = 'north'



local monitor_panel_factory = {}

monitor_panel_factory.default_params = function()
  local params_copy = {}
  params_copy.max_val = g_params.max_val
  params_copy.margin = g_params.margin
  params_copy.direction = g_params.direction
  return params_copy
end

monitor_panel_factory.get_layout = function(parameters)
  local direction = parameters.direction
  local layout = wibox.layout.flex.horizontal
  if direction == 'north' or direction == 'south' then
    layout = wibox.layout.flex.vertical
  end
  return layout
end


monitor_panel_factory.create = function(params)
  local parameters = params or g_params
  local ram = mb.create("", parameters)
  local cpu = mb.create("", parameters)
  local pow = mb.create("", parameters)
  local tmp = mb.create("", parameters)

  awesome.connect_signal("sysstat::ram", function(used, total)
      local label_val = math.floor(100 * (used / total))
      mb.set_val(ram, parameters, label_val)
      mb.set_label_text(ram, label_val .. '%')
  end)

  awesome.connect_signal("sysstat::cpu", function(cpu_val)
      mb.set_val(cpu, parameters, cpu_val)
      mb.set_label_text(cpu, cpu_val .. '%')
  end)

  awesome.connect_signal("sysstat::pow", function(pow_val, status)
      mb.set_val(pow, parameters, pow_val)
      mb.set_label_text(pow, pow_val .. '%')
  end)


  awesome.connect_signal("sysstat::temp", function(temp_val)
      mb.set_val(tmp, parameters, temp_val)
      mb.set_label_text(tmp,  temp_val .. '°C')
  end)

  local monitor_panel = wibox.widget(
  {
    {
      {
          ram,
          widget = wibox.container.margin,
          margins = dpi(parameters.bars_margin)
      },
      {
          cpu,
          widget = wibox.container.margin,
          margins = dpi(parameters.bars_margin)
      },
      {
          pow,
          widget = wibox.container.margin,
          margins = dpi(parameters.bars_margin)
      },
      {
          tmp,
          widget = wibox.container.margin,
          margins = dpi(parameters.bars_margin)
      },
      layout = monitor_panel_factory.get_layout(parameters)
    },
    forced_height = dpi(130),
    forced_width = dpi(400),
    widget = wibox.container.background
  })
  return monitor_panel
end

return monitor_panel_factory
