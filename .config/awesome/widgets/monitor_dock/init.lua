local gears       = require("gears")
local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local pb          = require("widgets.progress_bar")
local icons       = require("commons.icons")
local shape_utils = require("commons.shape")

local sw_bg = function(pbar, index, color)
    local r = pbar:get_children_by_id("arr")[1]:get_children()[index]:get_children_by_id("point")[1]
    r.bg = color
end


local set_val = function(pbar, pbar_parameters, val)
    for i = 1, 10
        do
            sw_bg(pbar, i, i <= val and (pbar_parameters.active_color or beautiful.pbar_active_color) or (pbar_parameters.bg_color or beautiful.pbar_bg_color))
        end
end


local create_monitor = function(pbar_parameters)
    return pb.create_shaped_points_pbar(pbar_parameters)
end


local create_text_label = function(text)
  return wibox.widget{
      text   = text,
      align = "center",
      forced_width = dpi(80),
      opacity = 1,
      font = beautiful.font_famaly .. " Bold 20",
      widget = wibox.widget.textbox,
  }
end

local create_monitor_with_icon = function(pbar, label, icon)
    return {
      icons.wbi(icon, beautiful.pbar_icon_size),
      pbar,
      label,
      layout = wibox.layout.align.horizontal
    }
end


local watchdog = function(signal, callback)
    awesome.connect_signal(signal, callback)
end


local monitor_dock = wibox(
{
    visible = true,
    ontop = false,
    height = dpi(180),
    width = dpi(550),
    bg = beautiful.col_transparent,
    type = "dock",
    border_width = dpi(4),
    border_color = beautiful.border_focus,
    shape =  shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
    screen = screen.primary,
})


local parameters = {}

local ram = create_monitor(parameters)
local ram_label = create_text_label("0%")

local cpu = create_monitor(parameters)
local cpu_label = create_text_label("0%")

local pow = create_monitor(parameters)
local pow_label = create_text_label("0%")

watchdog("sysstat::ram", function(used, total)
    local label_val = math.floor(100 * (used / total))
    local pbar_val = math.floor(label_val / 10)
    set_val(ram, parameters, pbar_val)
    ram_label.text = label_val .. '%'
end)

watchdog("sysstat::cpu", function(cpu_val)
    local pbar_val = math.floor(cpu_val / 10)
    set_val(cpu, parameters, pbar_val)
    cpu_label.text = cpu_val .. '%'
end)

watchdog("sysstat::pow", function(pow_val)
    local pbar_val = math.floor(pow_val / 10)
    set_val(pow, parameters, pbar_val)
    pow_label.text = pow_val .. '%'
end)


monitor_dock:setup {
    {
        create_monitor_with_icon(ram, ram_label, ""),
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    {
        create_monitor_with_icon(cpu, cpu_label, ""),
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    {
        create_monitor_with_icon(pow, pow_label, ""),
        widget = wibox.container.margin,
        margins = dpi(5)
    },
    layout = wibox.layout.fixed.vertical
}
awful.placement.top_left(monitor_dock, {honor_workarea=true, margins={left = 30, top = 70}})

return monitor_dock
