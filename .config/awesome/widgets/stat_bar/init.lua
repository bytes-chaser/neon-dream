local awful                = require("awful")
local wibox                = require("wibox")
local beautiful            = require("beautiful")
local dpi                  = beautiful.xresources.apply_dpi
local shape_utils          = require("commons.shape")
local monitor_panel        = require("widgets.monitor_panel")
local disk_monitor_panel   = require("widgets.disk_monitor_panel")
local processes            = require("widgets.processes")
local card                 = require("widgets.card")

local monitor_panel_params = monitor_panel.default_params()
monitor_panel_params.direction   = 'east'
monitor_panel_params.bars_margin = 10

local sys_headerless_mon_widget = monitor_panel.create(monitor_panel_params)
local sys_mon_widget = card.create_with_header("System", sys_headerless_mon_widget)


local processes_widget = card.create_with_header("Processes",  processes.create())


local disk_monitor_panel_params = disk_monitor_panel.default_params()
disk_monitor_panel_params.direction   = 'east'
disk_monitor_panel_params.bars_margin = 10
disk_monitor_panel_params.title_size  = 12

local disks_headerless_mon_widget = disk_monitor_panel.create(disk_monitor_panel_params)
local disks_mon_widget = card.create_with_header("Partitions", disks_headerless_mon_widget)

return {
  create = function(s)
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

    s.stats:setup{
      sys_mon_widget,
      processes_widget,
      disks_mon_widget,
      layout = wibox.layout.flex.vertical
    }

  end
}
