local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local pb        = require("widgets.progress_bar")
local icons     = require("commons.icons")

local sw_bg = function(pbar, index, color) 
    local r = pbar:get_children_by_id("arr")[1]:get_children()[index]:get_children_by_id("point")[1]
    r.bg = color
end


local set_val = function(pbar, pbar_parameters, val)
    for i = 1, 10
        do
            sw_bg(pbar, i, i <= val and pbar_parameters.active_color or pbar_parameters.bg_color)
        end  
end


local create_monitor = function(pbar_parameters)
    return pb.create_shaped_points_pbar(pbar_parameters)
end


local create_monitor_with_icon = function(pbar, icon, size)
    return{
        icons.wbi(icon, size),
        pbar,
        layout = wibox.layout.align.horizontal
    }
end


local watchdog = function(signal, callback)
    awesome.connect_signal(signal, callback)
end


monitor_dock = wibox(
{
    visible = true, 
    ontop = true, 
    height = dpi(35),
    width = dpi(1500),
    type = "dock", 
    screen = screen.primary,
})


local ram_pbar_parameters = {
    shape = gears.shape.circle,
    bg_color = '#ffffff', 
    active_color = '#00ff00', 
    p_heigth = 15,
    p_width = 15,
    p_margin = 5,
}


local ram = create_monitor(ram_pbar_parameters)
watchdog("sysstat::ram", function(used, total)
    set_val(ram, ram_pbar_parameters, math.floor(10 * (used / total))) 
end)

monitor_dock:setup {
    {
        create_monitor_with_icon(ram, "", 13),
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    layout = wibox.layout.align.vertical
}
awful.placement.bottom(monitor_dock)