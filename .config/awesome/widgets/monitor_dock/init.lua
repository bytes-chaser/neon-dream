local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local dpi         = beautiful.xresources.apply_dpi
local pb          = require("widgets.progress_bar")
local shape_utils = require("commons.shape")
local mb          = require("widgets.monitor_stat_bar")

local monitor_dock = wibox(
{
    visible = true,
    ontop = false,
    height = dpi(130),
    width = dpi(400),
    bg = beautiful.col_transparent,
    type = "dock",
    border_width = dpi(4),
    border_color = beautiful.border_focus,
    shape =  shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
    screen = screen.primary,
})


local parameters = {}

local ram = mb.create("", parameters)
local cpu = mb.create("", parameters)
local pow = mb.create("", parameters)

awesome.connect_signal("sysstat::ram", function(used, total)
    local label_val = math.floor(100 * (used / total))
    local pbar_val = math.floor(label_val / 10)
    mb.set_val(ram, parameters, pbar_val)
    ram[3].text = label_val .. '%'
end)

awesome.connect_signal("sysstat::cpu", function(cpu_val)
    local pbar_val = math.floor(cpu_val / 10)
    mb.set_val(cpu, parameters, pbar_val)
    cpu[3].text = cpu_val .. '%'
end)

awesome.connect_signal("sysstat::pow", function(pow_val, status)
    local pbar_val = math.floor(pow_val / 10)
    mb.set_val(pow, parameters, pbar_val)
    pow[3].text = pow_val .. '%'
end)


monitor_dock:setup {
    {
        ram,
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    {
        cpu,
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    {
        pow,
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    layout = wibox.layout.fixed.vertical
}
awful.placement.left(monitor_dock, {honor_workarea=true, margins={left = 30}})

return monitor_dock
