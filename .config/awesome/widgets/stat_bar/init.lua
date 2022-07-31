local awful                = require("awful")
local wibox                = require("wibox")
local beautiful            = require("beautiful")
local dpi                  = beautiful.xresources.apply_dpi
local pb                   = require("widgets.progress_bar")
local shape_utils          = require("commons.shape")
local mb                   = require("widgets.monitor_stat_bar_std")
local monitor_panel        = require("widgets.monitor_panel")
local disk_monitor_panel   = require("widgets.disk_monitor_panel")
local processes            = require("widgets.processes")
local card                 = require("widgets.card")

stat_bar = {}

stat_bar.create = function(s)
  s.stats = awful.wibar({
    position = "left",
    screen   = s,
    shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
    visible  = false,
    width    = dpi(300),
    height   = dpi(1000),
    margins  = {
      left = dpi(15)
    }
  })

  local monitor_panel_params = monitor_panel.default_params()
  monitor_panel_params.direction   = 'east'
  monitor_panel_params.bars_margin = 10

  local disk_monitor_panel_params = disk_monitor_panel.default_params()
  disk_monitor_panel_params.direction   = 'east'
  disk_monitor_panel_params.bars_margin = 10
  disk_monitor_panel_params.title_size  = 12

  s.stats:setup{
    card.create_with_header("System",     monitor_panel.create(monitor_panel_params)),
    card.create_with_header("Processes",  processes.create()),
    card.create_with_header("Partitions", disk_monitor_panel.create(disk_monitor_panel_params)),

    layout = wibox.layout.flex.vertical
  }

end

return stat_bar
