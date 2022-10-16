local awful                = require("awful")
local wibox                = require("wibox")
local dpi                  = require("beautiful").xresources.apply_dpi
local shape_utils          = require("commons.shape")
local card                 = require("widgets.card")
local amp                  = require("widgets.mon_panel")
local common_watchdogs     = require("panels.stat_bar.watchdogs")

local sys_stats_params       = amp.default_params()
sys_stats_params.direction   = 'east'
sys_stats_params.bars_margin = 10

local sys_stats_widget = card.create_with_header("System", amp.create(sys_stats_params, {
  {
    icon     = "",
    signal   = "sysstat::ram",
  },
  {
    icon     = "",
    signal   = "sysstat::cpu",
  },
  {
    icon     = "",
    signal   = "sysstat::pow",
  },
  {
    icon     = "",
    signal   = "sysstat::temp",
  },
}))


local processes_widget = card.create_with_header("Processes",  createWidget(require("widgets.processes")))

local disk_stats_params       = amp.default_params()
disk_stats_params.direction   = 'east'
disk_stats_params.margin      = 25
disk_stats_params.bars_margin = 10
disk_stats_params.title_size  = 12

local disks_stats_widget = card.create_with_header("Partitions", amp.create(disk_stats_params, {
  {
    icon     = "root",
    signal   = "sysstat:disk_root",
  },
  {
    icon     = "boot",
    signal   = "sysstat:disk_boot",
  },
  {
    icon     = "home",
    signal   = "sysstat:disk_home",

  },
}))


return {
  name = "stats_v1",
  watchdogs = common_watchdogs,
  create = function(s)

    local stat = awful.wibar({
      position = "left",
      screen   = s,
      shape    = shape_utils.default_frr,
      visible  = false,
      width    = dpi(300),
      height   = dpi(1020),
      margins  = {
        left = dpi(15)
      }
    })

    stat:setup{
      sys_stats_widget,
      processes_widget,
      disks_stats_widget,
      layout = wibox.layout.flex.vertical
    }

    return stat

  end
}
