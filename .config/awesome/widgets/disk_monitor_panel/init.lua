local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local dpi         = beautiful.xresources.apply_dpi
local pb          = require("widgets.progress_bar")
local shape_utils = require("commons.shape")
local mb          = require("widgets.monitor_stat_bar_std")

local parameters = {}
parameters.max_val = 100
parameters.margin = 25

local root = mb.create("root", parameters)
local boot = mb.create("boot", parameters)
local home = mb.create("home", parameters)

awesome.connect_signal("sysstat:disk_root", function(used, total)
    local label_val = math.ceil(100 * (used / total))
    mb.set_val(root, parameters, label_val)
    root[3].text = label_val .. '%'
end)

awesome.connect_signal("sysstat:disk_boot", function(used, total)
    local label_val = math.ceil(100 * (used / total))
    mb.set_val(boot, parameters, label_val)
    boot[3].text = label_val .. '%'
end)

awesome.connect_signal("sysstat:disk_home", function(used, total)
    local label_val = math.ceil(100 * (used / total))
    mb.set_val(home, parameters, label_val)
    home[3].text = label_val .. '%'
end)

local monitor_panel = wibox.widget(
{
  {
    {
        root,
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    {
        boot,
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    {
        home,
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    layout = wibox.layout.flex.vertical
  },
  forced_height = dpi(130),
  forced_width = dpi(400),
  widget = wibox.container.background
})

return monitor_panel
