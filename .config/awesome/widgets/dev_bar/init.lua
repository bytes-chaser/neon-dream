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
local repos                = require("widgets.repos")
local card                 = require("widgets.card")
local packages             = require("widgets.packages_list")

local dev_bar = {}

dev_bar.create = function(s)
  s.dev = awful.wibar({
    position = "left",
    screen   = s,
    shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
    visible  = false,
    width    = dpi(500),
    height   = dpi(1000),
    margins  = {
      left = dpi(15)
    }
  })

  s.dev:setup{
    card.create_with_header("Packages", packages.create()),
    card.create_with_header("Repositories", repos.create()),
    layout = wibox.layout.flex.vertical
  }


end

return dev_bar
