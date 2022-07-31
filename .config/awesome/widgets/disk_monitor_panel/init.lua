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
g_params.margin = 25
g_params.direction = 'north'
g_params.title_size = 12
local monitor_panel_factory = {}


monitor_panel_factory.default_params = function()
  local params_copy = {}
  params_copy.max_val = g_params.max_val
  params_copy.bars_margin = g_params.bars_margin
  params_copy.margin = g_params.margin
  params_copy.direction = g_params.direction
  params_copy.title_size = g_params.title_size
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
  local root = mb.create("root", parameters)
  local boot = mb.create("boot", parameters)
  local home = mb.create("home", parameters)

  awesome.connect_signal("sysstat:disk_root", function(used, total)
      local label_val = math.ceil(100 * (used / total))
      mb.set_val(root, parameters, label_val)
      mb.set_label_text(root, label_val .. '%')
  end)

  awesome.connect_signal("sysstat:disk_boot", function(used, total)
      local label_val = math.ceil(100 * (used / total))
      mb.set_val(boot, parameters, label_val)
      mb.set_label_text(boot, label_val .. '%')
  end)

  awesome.connect_signal("sysstat:disk_home", function(used, total)
      local label_val = math.ceil(100 * (used / total))
      mb.set_val(home, parameters, label_val)
      mb.set_label_text(home, label_val .. '%')
  end)

  local monitor_panel = wibox.widget(
  {
    {
      {
          root,
          widget = wibox.container.margin,
          margins = dpi(parameters.bars_margin)
      },
      {
          boot,
          widget = wibox.container.margin,
          margins = dpi(parameters.bars_margin)
      },
      {
          home,
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
